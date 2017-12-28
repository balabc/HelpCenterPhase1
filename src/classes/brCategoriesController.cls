public with sharing class brCategoriesController {
    
    @AuraEnabled 
    public static List<brCategoriesCatalogModel> getCatalog(String selectId, String articleType, String dataCategoryName, String url) {
        brSecurityService.performAccessCheck('read',articleType, new List<String>{'UrlName','KnowledgeArticleId'});

        String idArticle = brArticleContentServiceSelector.getArticleByUrlKnowledgeArticleId(url, articleType);
        if (idArticle == null) {
            idArticle = selectId;
        }
        
        return brCategoriesCatalogService.getCatalog(idArticle, articleType, dataCategoryName);
    }
    
}