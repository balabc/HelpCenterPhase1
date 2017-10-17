public with sharing class brCategoriesController {
    @AuraEnabled 
    public static List<brCategoriesCatalogModel> getCatalog(String selectId) { 
        return brCategoriesCatalogService.getCatalog(selectId);
    }
}