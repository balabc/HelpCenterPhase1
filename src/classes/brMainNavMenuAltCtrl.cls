public with sharing class brMainNavMenuAltCtrl {
    @AuraEnabled
    public static List<String> getLabels() {
        return brMainNavMenuService.getLabels();
    }
}