public with sharing class brArticleContentController {
    
	@AuraEnabled 
    public static Map<String, String> getDataForArticle(String articleId) { 
        return brArticleContentService.getDataForArticle(articleId);
    }

	@AuraEnabled
    public static brArticleModel getArticleContent(String articleId) {
        return brArticleContentService.getArticleContent(articleId);
    }

    @AuraEnabled
    public static List<SObject> getListArticleInCurrentCategory(String articleId) {
        return brArticleContentService.getListArticleInCurrentCategory(articleId);
    }

}