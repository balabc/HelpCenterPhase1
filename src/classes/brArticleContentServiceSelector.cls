public with sharing class brArticleContentServiceSelector {

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

}