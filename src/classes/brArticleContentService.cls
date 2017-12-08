public with sharing class brArticleContentService {

    public static Map<String, String> getDataForArticle(String articleId) { 
        Map<String, String> result = new Map<String, String>();
        String articleType = Id.valueOf(articleId).getSObjectType().getDescribe().getName();
        String dataCategory = brArticleContentServiceSelector.getDataCategoryByArticleTypeAndId(articleType, articleId);
        
        result.put('articleType', articleType);
        result.put('dataCategory', dataCategory);
        
        return result;
    }
    
}