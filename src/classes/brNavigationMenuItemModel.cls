public with sharing class brNavigationMenuItemModel {
    
    @AuraEnabled    
    public String id {get;set;}    
    
    @AuraEnabled    
    public String label {get;set;}   
    
    @AuraEnabled    
    public String parentId {get;set;}   
    
    @AuraEnabled    
    public Integer position {get;set;}   
    
    @AuraEnabled    
    public String target {get;set;}   
    
    @AuraEnabled    
    public String type {get;set;}   
    
    @AuraEnabled    
    public Boolean hasSubMenu {get;set;}      
    
    @AuraEnabled    
    public List<brNavigationMenuItemModel> subMenu {get;set;}     
                        
}