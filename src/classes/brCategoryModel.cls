public with sharing class brCategoryModel {
    public class CategoryWrapper {   
        @AuraEnabled    
        public String id {get;set;}
        
        @AuraEnabled
        public String parent {get;set;}
        
        @AuraEnabled
        public String text {get;set;}
        
        public CategoryWrapper(String id, String name,String parentid) {
            this.id=id ;//+ '__c';
            this.parent = (parentid == null) ? '#' : parentid;// + '__c';
            this.text = name;
        }
    }     
}