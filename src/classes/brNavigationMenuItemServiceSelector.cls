public with sharing class brNavigationMenuItemServiceSelector {
    
    public static List<List<SObject>> getArticle(String url, String acticleTypes) {
        List<List<SObject>> articles = search.query('FIND \'' + url + '\' RETURNING ' + acticleTypes + '');		    						 	      
        return articles;            
    } 
    
    public static List<NavigationMenuItem> getNavigationMenuItem() {
        List<NavigationMenuItem> itemList = new List<NavigationMenuItem>();
        itemList = [SELECT id, Label, NavigationLinkSetId, Position, SystemModstamp, Target, TargetPrefs, Type, ParentId FROM NavigationMenuItem ORDER BY Position];
        return itemList;
    } 
    
    public static List<brCommunity_Menu_Map__mdt> getMetaDataMenu() {
        List<brCommunity_Menu_Map__mdt> itemList = new List<brCommunity_Menu_Map__mdt>();
        itemList = [SELECT MasterLabel, Data_Category_Group__c, Menu_Target__c, Object_Name__c FROM brCommunity_Menu_Map__mdt];
        return itemList;
    }
    
    public static List<brCommunity_Menu_Map__mdt> getMetaDataMenuByArticleType(String articleType) {
        List<brCommunity_Menu_Map__mdt> itemList = new List<brCommunity_Menu_Map__mdt>();
        itemList = [SELECT MasterLabel, Data_Category_Group__c, Menu_Target__c, Object_Name__c FROM brCommunity_Menu_Map__mdt WHERE Object_Name__c = :articleType];
        return itemList;
    }
    
}