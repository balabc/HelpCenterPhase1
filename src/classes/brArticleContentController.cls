public with sharing class brArticleContentController {
    
	@AuraEnabled 
    public static Map<String, String> getDataForArticle(String articleId) { 
        return brArticleContentService.getDataForArticle(articleId);
    }
    
}