public with sharing class brArticleContentServiceSelector {

    /**
     * Returns data category for those article type and article id
     *
     * {@inheritDoc}
     *
     * @param       articleType     article type
     * @param       articleId     article id
     * @return      data category
     * @see         String
     */
    public static String getDataCategoryByArticleTypeAndId(String articleType, String articleId) { 
    	articleType = articleType.replace('__kav','');
    	List<sObject> cats = Database.query('SELECT id, ParentId, DataCategoryGroupName, DataCategoryName FROM ' + articleType + '__DataCategorySelection WHERE ParentId = \'' + articleId + '\'');
    	return String.valueOf(cats[0].get('DataCategoryGroupName'));
    }

    public static sObject getArticleById(String articleId) {
		String articleType = Id.valueOf(articleId).getSObjectType().getDescribe().getName();
        String queryFields = '';

        if(articleType == 'Public__kav') {
            queryFields = ',Article__c';

        } else if(articleType == 'Learning__kav') {
            queryFields = ',Article__c,Guide_Title__c,Sort_Oder_in_Category__c,Back_Button_URL__c,Next_Button_Text__c,Next_Button_URL__c';

        } else if(articleType == 'University__kav') {
            queryFields = ',Description__c,Additional_Resources__c,Next_Video_URL__c,Next_Video_Link_Text__c,Prev_Video_URL__c,Prev_Video_Link_Text__c,Video_URL__c';
        }

        String q = 'SELECT KnowledgeArticleId, Title' + queryFields + ' FROM ' + articleType + ' WHERE Id = \'' + articleId + '\' LIMIT 1';

    	return (sObject) Database.query(q);
    }

    public static String getDataCategoryNameByArticleId(String articleId, String articleType) {
        String q = 'SELECT DataCategoryName FROM ' + articleType.replace('__kav','') + '__DataCategorySelection WHERE (ParentId = \'' + articleId + '\') AND (Parent.PublishStatus = \'Online\') LIMIT 1';
        SObject result = Database.query(q);
        return String.valueOf(result.get('DataCategoryName'));
    }

    public static List<sObject> getArticleListInDataCategory(String articleType) {
        String q = 'SELECT ParentId, DataCategoryName FROM ' + articleType.replace('__kav','') + '__DataCategorySelection WHERE Parent.PublishStatus = \'Online\'';
        return Database.query(q);
    }

    public static List<sObject> getArticleListByDataCategory(String articleType, List<String> ids) {
        String q = 'SELECT KnowledgeArticleId, Title, Nav_Title__c, Id, Sort_Oder_in_Category__c FROM ' + articleType + ' WHERE (PublishStatus = \'Online\') AND (Id IN :ids) ORDER BY Sort_Oder_in_Category__c ASC';
        return Database.query(q);

    }

}