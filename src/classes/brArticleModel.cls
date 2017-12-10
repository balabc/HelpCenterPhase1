public with sharing class brArticleModel { 
    
    @AuraEnabled    
    public String id {get;set;}

    @AuraEnabled
    public sObject item {get;set;}

    @AuraEnabled    
    public String articleType {get;set;}

    @AuraEnabled
    public String articleSections {get;set;}

    @AuraEnabled
    public Boolean active {get;set;}    
    
    @AuraEnabled 
    public String title {get;set;}  
    
    @AuraEnabled 
    public Set<String> categories {get;set;}     
                  
}