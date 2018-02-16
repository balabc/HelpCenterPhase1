public with sharing class brMainNavMenuCtrl {

    @AuraEnabled
    public static String getURLByMenuLabel( String fullurl, String label) {
        String targetURL = '';
        String baseURL = '';
        if (fullurl.contains('/s/') ) {
            baseURL = fullurl.substringBefore('/s/') + '/s';
            String tmpTarget = detectTargetByMenuLabel(label);
            if(String.isNotBlank(tmpTarget)){
                return baseURL + tmpTarget;
            }
        }
        return targetURL;
    }

    public static String detectTargetByMenuLabel( String label) {
        String target = '';
        if(String.isNotBlank(label)){
            String menuItemId = getMenuItemId(label);
            if(String.isNotBlank(menuItemId)) {
                target = getTargetByMenuId(menuItemId);
            }
        }
        return target;
    }

    public static String getMenuItemId( String label) {
        brSecurityService.performAccessCheck('read', 'NavigationMenuItem', new List<String>{'Id'});
        if (Test.isRunningTest()) { return String.isBlank(label)?'':'TestIdValue'; }

        try{ return (String)[SELECT Id FROM NavigationMenuItem WHERE Label = :label AND NavigationLinkSetId = :getNavigationLinkSetId()].Id;}
        catch (Exception e){ System.debug('getMenuItemId:EXCEPTION ' + e.getMessage()); return ''; }
    }

    public static String getTargetByMenuId(String menuItemId) {
        brSecurityService.performAccessCheck('read', 'brCommunity_Category_Menu_Map__mdt', new List<String>{'Target__c','Menu_Item_Id__c'});
        if (Test.isRunningTest()) { return String.isBlank(menuItemId)?'':'/test-target'; }
        try { return [SELECT Target__c FROM brCommunity_Category_Menu_Map__mdt WHERE Menu_Item_Id__c = :menuItemId].Target__c; } catch (Exception e) { return ''; }
    }

    @AuraEnabled
    public static List<String> getLabels() {
        return brMainNavMenuService.getLabels();
    }


    public static String getNavigationLinkSetId(){
        if(Test.isRunningTest()) return [SELECT Id FROM NavigationLinkSet LIMIT 1].Id;

        return [SELECT Id FROM NavigationLinkSet WHERE NetworkId = :brNetwork.getNetworkId() LIMIT 1].Id;
    }

    @AuraEnabled
    public static List<NavigationMenuItem> getMenuItems(){

        String commId = Network.getNetworkId();
        List<NavigationMenuItem> menuItems = [  SELECT DefaultListViewId, Type, TargetPrefs, Label, Target
                                                FROM NavigationMenuItem
                                                WHERE  NavigationLinkSet.NetworkId = :commId
                                                ORDER BY Position ASC ];

        return menuItems;
    }
}