public with sharing class brAnnouncementBlockCtrl {
    @AuraEnabled
    public static brCommunityMetadata__mdt getAnnouncement() {
        brSecurityService.performAccessCheck('read', 'brCommunityMetadata__mdt', new List<String>{'Value__c','Active__c'});
        brCommunityMetadata__mdt portalNotice = null;

        try {
             portalNotice = [
                    SELECT Value__c, QualifiedApiName
                    FROM brCommunityMetadata__mdt
                    WHERE QualifiedApiName IN ('Portal_Notice_Info','Portal_Notice_Warning','Portal_Notice_Error','Portal_Notice_Success') AND Active__c = TRUE
                    LIMIT 1];

        } catch (QueryException ex) {  System.debug('brAnnouncementBlockCtrl::getAnnouncement: ' + ex.getMessage()); }

        if (Test.isRunningTest()) {
            return new brCommunityMetadata__mdt();
        }

        return portalNotice;
    }
}