
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
        try{
            return (String)[SELECT Id FROM NavigationMenuItem WHERE Label = :label].Id;
        }catch (Exception e){
            return '';
        }
    }

    public static String getTargetByMenuId(String menuItemId) {
        try {
            return [SELECT Target__c FROM brCommunity_Category_Menu_Map__mdt WHERE Menu_Item_Id__c = :menuItemId].Target__c;
        } catch (Exception e) {
            return '';
        }
    }

    @AuraEnabled
    public static List<String> getLabels() {
        return brMainNavMenuService.getLabels();
    }
}