public with sharing class brArticleContentServiceSelector {

    public static String getDataCategoryByArticleTypeAndId(String articleType, String articleId) { 
    	articleType = articleType.replace('__kav','');
    	List<sObject> cats = Database.query('SELECT id, ParentId, DataCategoryGroupName, DataCategoryName FROM ' + articleType + '__DataCategorySelection WHERE ParentId = \'' + articleId + '\'');
    	return String.valueOf(cats[0].get('DataCategoryGroupName'));
    }
    
}