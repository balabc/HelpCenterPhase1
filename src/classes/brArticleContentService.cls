public with sharing class brArticleContentService {

    public static Map<String, String> getDataForArticle(String articleId) { 
        Map<String, String> result = new Map<String, String>();
        String articleType = Id.valueOf(articleId).getSObjectType().getDescribe().getName();
        String dataCategory = brArticleContentServiceSelector.getDataCategoryByArticleTypeAndId(articleType, articleId);
        
        result.put('articleType', articleType);
        result.put('dataCategory', dataCategory);
        
        return result;
    }

    public static brArticleModel getArticleContent(String articleId) {
        brArticleModel article = new brArticleModel();
        article.item = brArticleContentServiceSelector.getArticleById(articleId);
        article.id = articleId;
        article.articleType = Id.valueOf(articleId).getSObjectType().getDescribe().getName();

        return article;
    }

}