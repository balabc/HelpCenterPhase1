public with sharing class brCategoriesCatalogModel {
    @AuraEnabled    
    public String id {get;set;}

    @AuraEnabled    
    public String name {get;set;}
    
    /*@AuraEnabled    
    public String parent {get;set;}*/
    
    @AuraEnabled
    public Boolean active {get;set;}
    
    @AuraEnabled 
    public List<brArticleModel> articles {get;set;}
    
    @AuraEnabled
    public List<brCategoriesCatalogModel> categories{get;set;}
    
    public brCategoriesCatalogModel() {
        articles = new List<brArticleModel>();
        active = false;
    }
}