public with sharing class brNavigationMenuItemServiceSelector {
 
     public static List<NavigationMenuItem> getNavigationMenuItem() {
        List<NavigationMenuItem> itemList = new List<NavigationMenuItem>();
        itemList = [SELECT id, Label, NavigationLinkSetId, Position, SystemModstamp, Target, TargetPrefs, Type, ParentId FROM NavigationMenuItem ORDER BY Position];
        return itemList;
    }
    
}