public with sharing class brCategoriesController {
    
    @AuraEnabled 
    public static List<brCategoriesCatalogModel> getCatalog(String selectId, String articleType, String dataCategoryName) { 
        return brCategoriesCatalogService.getCatalog(selectId, articleType, dataCategoryName);
    }
    
    /*@AuraEnabled 
    public static brCategoriesCatalogModel getCatalogList(String categoryName, String articleType, String dataCategoryName) { 
        return brCategoriesCatalogService.getCatalogList(categoryName, articleType, dataCategoryName);
    }*/
    
}