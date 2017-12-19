public with sharing class brArticleModel {

    /**
     * article id
     */
    @AuraEnabled    
    public String id {get;set;}

    /**
     *  data/elements articles
     */
    @AuraEnabled
    public sObject item {get;set;}

    /**
     * article type
     */
    @AuraEnabled    
    public String articleType {get;set;}

    /**
     * inner elements in formats as 'anchor:title;'
     */
    @AuraEnabled
    public String articleSections {get;set;}

    /**
     * status active
     */
    @AuraEnabled
    public Boolean active {get;set;}

    /**
     * title
     */
    @AuraEnabled 
    public String title {get;set;}

    /**
     * categories where this articles contains
     */
    @AuraEnabled 
    public Set<String> categories {get;set;}     
                  
}