public with sharing class brAlgoliaSearchCtrl {

    /**
     * Returns api key for algolia.
     *
     * {@inheritDoc}
     * 
     * @return      string if api key exist else return null
     * @see         String
     */
    @AuraEnabled
    public static String getApiKey() {
        brAlgolia_Profile_Setting__c setting = brAlgolia_Profile_Setting__c.getInstance(UserInfo.getProfileId());
        brSecurityService.performAccessCheck('read', 'brAlgolia_Profile_Setting__c', new List<String>{'Secured_Api_key__c'});

        if (setting.Secured_Api_key__c != null) {
            return setting.Secured_Api_key__c;
        } else {
            return null;
        }
    }
}