public with sharing class brNavigationMenuItemServiceSelector {
    
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
    
}