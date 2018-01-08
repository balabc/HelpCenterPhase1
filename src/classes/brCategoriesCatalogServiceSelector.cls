public with sharing class brCategoriesCatalogServiceSelector {
    
    public static List<sObject> getArticles(String articleType) {   
        List<sObject> articles;
        try {
            if (articleType == 'University__kav') {
                articles = Database.query('SELECT KnowledgeArticleId, Title, Nav_Title__c, id, Sort_Oder_in_Category__c, UrlName FROM ' + articleType + ' WHERE PublishStatus = \'Online\' ORDER BY Sort_Oder_in_Category__c ASC');
            } else {
                articles = Database.query('SELECT KnowledgeArticleId, Title, Nav_Title__c, Section_Anchors__c, id, Sort_Oder_in_Category__c, UrlName FROM ' + articleType + ' WHERE PublishStatus = \'Online\' ORDER BY Sort_Oder_in_Category__c ASC');
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            articles = null;
        }
        return articles;
    } 
    
    public static List<sObject> getArticleCategories(String articleType) { 
    	articleType = articleType.replace('__kav','');
        try {
    	    List<sObject> cats = Database.query('SELECT id, ParentId, DataCategoryGroupName, DataCategoryName FROM ' + articleType + '__DataCategorySelection');
            return cats;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }
    
}