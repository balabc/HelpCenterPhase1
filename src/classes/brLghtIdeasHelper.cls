public class brLghtIdeasHelper {

	public static void addSubscriberToIdea(Id usrId, Id ideaId){
		brIdeaSubscription__c subscr = new brIdeaSubscription__c(
				Idea__c = ideaId,
				User__c = usrId,
				Token__c = brUtils.generateToken(50)
			);

		insert subscr;
	}

	public static List<Map<String, String>> getCategoryOptions(String source, String zoneName){
		List<Map<String, String>> listArray = new List<Map<String, String>>();
		Map<String, String> listItem;
		List<String> catZones;
		Boolean containZone;

		if (source == 'Custom settings') {
			List<brLghtIdeasCategories__c> rows = [SELECT Name, Label__c, Parent__c, Zone__c
                                                    FROM brLghtIdeasCategories__c
                                                    ORDER BY Order__c ASC
                                                    LIMIT 1000];

			for (brLghtIdeasCategories__c row : rows) {
				if (zoneName != null && zoneName != '') {
					if (row.Zone__c == null) continue;

					catZones = String.valueOf(row.Zone__c).split(',');
					containZone = false;

					for (String zn : catZones) {
						if (zn == zoneName) containZone = true;
					}

					if (!containZone) continue;
				}

				listItem = new Map<String, String>();
				listItem.put('value', row.Name);
				listItem.put('label', row.Label__c);
				listItem.put('parent', row.Parent__c);
				listArray.add(listItem);
			}
		} else {
			Schema.DescribeFieldResult fieldResult = Idea.Categories.getDescribe();
			List<Schema.PicklistEntry> categoryPicklistEntries = fieldResult.getPicklistValues();

			for (Schema.PicklistEntry item : categoryPicklistEntries) {
				listItem = new Map<String, String>();
				listItem.put('value', item.getValue());
				listItem.put('label', item.getLabel());
				listArray.add(listItem);
			}
		}

		return listArray;
	}


	public static List<Map<String, String>> getStatusOptions(){
		List<Map<String, String>> listArray = new List<Map<String, String>>();
		Map<String, String> listItem;
        Schema.DescribeFieldResult fieldResult = Idea.Status.getDescribe();
        List<Schema.PicklistEntry> statusPicklistEntries = fieldResult.getPicklistValues();

		for (Schema.PicklistEntry item : statusPicklistEntries) {
			listItem = new Map<String, String>();
			listItem.put('value', item.getValue());
			listItem.put('label', item.getLabel());
			listArray.add(listItem);
		}

		return listArray;
	}


	public static String compileWhereStatement(String communityName,  Map<String,String> filterData) {
        String userId = UserInfo.getUserId();
		Id communityId = brLghtIdeasHelper.getCommunityId(communityName);
		List<String> whereList = new List<String>();
		List<String> searchIds;
		String searchQuery, category, status, ideaTheme, showBy, searchByTitleOnly;

		if (filterData == null) return '';

        searchQuery = filterData.get('search');
        searchByTitleOnly = filterData.get('search_by_title');
		category = filterData.get('category');
		status = filterData.get('status');
		ideaTheme = filterData.get('idea_theme');
        showBy = filterData.get('showBy');

        if (String.isNotBlank(category))
			whereList.add('Categories INCLUDES (\'' + String.escapeSingleQuotes(category) + '\')');

        if (String.isNotBlank(status))
			whereList.add('Status = \'' + String.escapeSingleQuotes(status) + '\'');

		if (String.isNotBlank(ideaTheme))
			whereList.add('IdeaThemeID = \'' + String.escapeSingleQuotes(ideaTheme) + '\'');

        if (String.isNotBlank(showBy)) {
			if (showBy == 'createdByMe') {
                whereList.add('CreatedById = \'' + userId + '\'') ;
            } else if (showBy == 'commentedByMe') {
                searchIds = new List<String>();

                List<AggregateResult> res = [SELECT IdeaId FROM IdeaComment WHERE CommunityId = :communityId AND CreatedById = :userId GROUP BY IdeaId];

                for (AggregateResult resRow : res) {
                    searchIds.add(String.valueOf(resRow.get('IdeaId')));
                }

                whereList.add('Id IN (\'' + String.join(searchIds, '\',\'') + '\')');
            }
        }

		if (String.isNotBlank(searchQuery)) {
			searchIds = new List<String>();
			List<List<SObject>> searchList;

            if (String.isNotBlank(searchByTitleOnly) && searchByTitleOnly == 'true') {
				List<String> searchWords = String.escapeSingleQuotes(searchQuery).split('\\s+');
                List<String> titleWhereList = new List<String>();
                String titleQueryString = '(';

                for (String searchWord : searchWords) {
                    titleWhereList.add('Title LIKE \'%' + searchWord + '%\'');
                }

                titleQueryString = titleQueryString + String.join(titleWhereList, ' OR ') + ')';

                whereList.add(titleQueryString);
            } else {
                searchList = [FIND :searchQuery IN ALL FIELDS RETURNING Idea(Id) LIMIT 50];

                for (SObject obj : searchList[0]) {
                    searchIds.add(obj.Id);
                }

                whereList.add('Id IN (\'' + String.join(searchIds, '\',\'') + '\')');
            }
		}

        return String.join(whereList, ' AND ');
    }


	public static String compileOrderByStatement(String orderByData) {
        String orderByClause = 'CreatedDate DESC';

        if (String.isNotBlank(orderByData)) {
            if (orderByData == 'Trending') {
                orderByClause = 'LastCommentDate DESC NULLS LAST, CreatedDate DESC';
            } else if (orderByData == 'Popular') {
                orderByClause = 'VoteTotal DESC, CreatedDate DESC';
            }
        }

        return orderByClause;
    }


	public static String getCommunityId(String communityName) {
		if (String.isBlank(communityName)) {
			communityName = brLghtIdeasHelper.getConfigValue('community');
		}

		if (communityName == '') {
			System.debug('Cannot find community name within settings');
			return '';
		}

		try {
			Community community = [SELECT Id FROM Community WHERE Name = :communityName LIMIT 1];
			return community.Id;
		} catch (Exception e) {
			System.debug('No communities with name "' + communityName + '"');
		}

		return '';
	}


	public static String getCommunityUrlByZoneId(Id zoneId){
        if (Test.isRunningTest()) return 'test.com';

        Community zone = [SELECT NetworkId FROM Community WHERE Id = :zoneId];
        ConnectApi.Community comm = ConnectApi.Communities.getCommunity(zone.NetworkId);

        return comm.SiteUrl;
    }


	public static String getConfigValue(String name) {
		for (brLghtIdeasSettings__c row : [SELECT Name, Value__c FROM brLghtIdeasSettings__c LIMIT 100]) {
			if (row.Name == name) return row.Value__c;
		}

		return '';
	}


	public static Map<String, String> getStatusUpdateSettings(){
		String settings = brLghtIdeasHelper.getConfigValue('status_update');
		Map<String, String> settingsMap = new Map<String, String>();
		Boolean isEnabled = false;
		Decimal threshold = 0;

		try {
			JSONParser parser = JSON.createParser(settings);
			String paramName;

			while (parser.nextToken() != null) {
				if (parser.getCurrentToken() != JSONToken.FIELD_NAME) continue;

				paramName = parser.getText();

				parser.nextToken();

				settingsMap.put(paramName, parser.getText());
			}

			isEnabled = Boolean.valueOf(settingsMap.get('active'));
			threshold = Decimal.valueOf(settingsMap.get('threshold'));

		} catch (Exception e) {
			System.debug('brLghtIdeasHelper::getStatusUpdateSettings:' + e.getMessage());
			return null;
		}

		if (isEnabled
				&& (threshold < 1
						|| String.isBlank(settingsMap.get('original_status'))
						|| String.isBlank(settingsMap.get('new_status')))
				) {

			System.debug('brLghtIdeasHelper::getStatusUpdateSettings: update status settings is not populated correctly');
			return null;
		}

		return settingsMap;
	}


	public static String getDefaultStatusValue(){
		Schema.DescribeFieldResult fieldResult = Idea.Status.getDescribe();
		List <Schema.PicklistEntry> pickVals = fieldResult.getPicklistValues();

		for (Schema.PicklistEntry peItem : pickVals) {
			if (peItem.isDefaultValue()) {
				return peItem.getValue();
			}
		}

		return '';
	}


	public static void performAccessCheck(String accessType) {
		Schema.DescribeSObjectResult ideaDescribe = Idea.sObjectType.getDescribe();
        Schema.DescribeSObjectResult voteDescribe = Vote.sObjectType.getDescribe();
        Schema.DescribeSObjectResult commentDescribe = IdeaComment.sObjectType.getDescribe();
		Schema.DescribeSObjectResult networkDescribe = Network.sObjectType.getDescribe();

		if (!ideaDescribe.isAccessible()
				|| (accessType == 'create' && !ideaDescribe.isCreateable())
				|| (accessType == 'edit' && !ideaDescribe.isUpdateable())
				|| (accessType == 'search' && !ideaDescribe.isSearchable()))
			throw new AuraHandledException('Access not granted');

		if (accessType == 'create_vote' && !voteDescribe.isAccessible()
				|| accessType == 'create_vote' && !voteDescribe.isCreateable()) {
			throw new AuraHandledException('Access not granted');
		}

        if ((accessType == 'read_comments' && !commentDescribe.isAccessible())
				|| (accessType == 'create_comments') && !commentDescribe.isCreateable()) {
			throw new AuraHandledException('Access not granted');
		}

		if ((accessType == 'read_network' && !networkDescribe.isAccessible())){
			throw new AuraHandledException('Access not granted');
		}
	}

    public static void unsubscribeUserFromIdea(String ideaId, String userId) {
        List<brIdeaSubscription__c> subscr = [SELECT Id FROM brIdeaSubscription__c
                                                    WHERE Idea__c = :ideaId
                                                        AND User__c = :userId];

        delete subscr;
    }

    public static void unsubscribeFromIdeaByToken(String tokenString) {
        brIdeaSubscription__c subscr = [SELECT Id FROM brIdeaSubscription__c
                                              WHERE Token__c = :tokenString LIMIT 1];

        delete subscr;
    }
}