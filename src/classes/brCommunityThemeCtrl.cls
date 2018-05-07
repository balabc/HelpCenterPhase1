public with sharing class brCommunityThemeCtrl {
    @AuraEnabled
    public static String getAnnouncement() {
        brSecurityService.performAccessCheck('read', 'brCommunityMetadata__mdt', new List<String>{'Value__c'});
        String message = null;

        try {
            for (brCommunityMetadata__mdt communityMetadata : [SELECT MasterLabel, Active__c, Value__c FROM brCommunityMetadata__mdt]) {
                if (communityMetadata.MasterLabel == 'Portal Notice') {
                    if (communityMetadata.Active__c) {
                        message = communityMetadata.Value__c;
                    }
                }
            }
        } catch (QueryException ex) {
            System.debug('brCommunityThemeCtrl::getAnnouncement: ' + ex.getMessage());
        }

        if (Test.isRunningTest()) {
            return 'test portal notice';
        }

        return message;
    }
}