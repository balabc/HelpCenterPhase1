public with sharing class brCategoriesController {
    
    @AuraEnabled 
    public static List<brCategoriesCatalogModel> getCatalog(String selectId, String articleType, String dataCategoryName, String url) {

        String idArticle = brArticleContentServiceSelector.getArticleByUrlKnowledgeArticleId(url, articleType);
        if (idArticle == null) {
            idArticle = selectId;
        }

        return brCategoriesCatalogService.getCatalog(idArticle, articleType, dataCategoryName);
    }
    
    /*@AuraEnabled 
    public static brCategoriesCatalogModel getCatalogList(String categoryName, String articleType, String dataCategoryName) { 
        return brCategoriesCatalogService.getCatalogList(categoryName, articleType, dataCategoryName);
    }*/
    
}