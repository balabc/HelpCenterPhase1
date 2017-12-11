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

    public static List<SObject> getListArticleInCurrentCategory(String articleId) {
        String articleType = Id.valueOf(articleId).getSObjectType().getDescribe().getName();

        String dataCategory = brArticleContentServiceSelector.getDataCategoryNameByArticleId(articleId, articleType);
        List<SObject> items = brArticleContentServiceSelector.getArticleListInDataCategory(articleType);
        List<String> ids = new List<String>();

        for (SObject item : items) {
            if (dataCategory == String.valueOf(item.get('DataCategoryName'))) {
                if (!String.isEmpty(String.valueOf(item.get('ParentId')))) {
                    ids.add(String.valueOf(item.get('ParentId')));
                }
            }
        }

        List<SObject> result = brArticleContentServiceSelector.getArticleListByDataCategory(articleType, ids);

        return result;
    }

}