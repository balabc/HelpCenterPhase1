public with sharing class brCategoriesCatalogServiceSelector {
    
    public static List<sObject> getArticles(String articleType) {   
    	List<sObject> articles = Database.query('SELECT KnowledgeArticleId, Title, Nav_Title__c, Article_Sections__c, id FROM '+articleType+' WHERE PublishStatus = \'Online\'');		    						 	      
        return articles;            
    } 
    
    public static List<sObject> getArticleCategories(String articleType) { 
    	articleType = articleType.replace('__kav','');
    	List<sObject> cats = Database.query('SELECT id, ParentId, DataCategoryGroupName, DataCategoryName FROM '+articleType+'__DataCategorySelection');
    	return cats;
    }
    
}