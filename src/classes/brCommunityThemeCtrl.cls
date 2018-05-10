public with sharing class brCommunityThemeCtrl {
    @AuraEnabled
    public static brCommunityMetadata__mdt getAnnouncement() {
        brSecurityService.performAccessCheck('read', 'brCommunityMetadata__mdt', new List<String>{'Value__c','Active__c'});

        try {
            List<brCommunityMetadata__mdt> portalNotice = [
                    SELECT Value__c, QualifiedApiName
                    FROM brCommunityMetadata__mdt
                    WHERE QualifiedApiName IN ('Portal_Notice_Info','Portal_Notice_Warning','Portal_Notice_Error','Portal_Notice_Success') AND Active__c = TRUE
                    LIMIT 1];

            if(portalNotice.size() > 0) {
                return portalNotice[0];
            }

        } catch (QueryException ex) {  System.debug('brCommunityThemeCtrl::getAnnouncement: ' + ex.getMessage()); }

        if (Test.isRunningTest()) {
            //message = 'test portal notice';
        }

        return null;
    }
}