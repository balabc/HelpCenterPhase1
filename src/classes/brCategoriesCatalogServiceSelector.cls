public with sharing class brCategoriesCatalogServiceSelector {
    public static List<Knowledge__kav> getArticles() {   
    	List<Knowledge__kav> articles = [SELECT KnowledgeArticleId, Title, Nav_Title__c, 
    											(SELECT ParentId, DataCategoryGroupName, DataCategoryName FROM DataCategorySelections) 
    									 FROM Knowledge__kav 
    									 WHERE 
    									 	PublishStatus = 'Online'];       
        return articles;            
    }       
}