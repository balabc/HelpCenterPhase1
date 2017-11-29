public with sharing class brAlgoliaSearchCtrl {
	
    @AuraEnabled
    public static String getApiKey () {
    	brAlgolia_Profile_Setting__c setting = brAlgolia_Profile_Setting__c.getInstance(UserInfo.getProfileId());
    	if (setting.Secured_Api_key__c != null) {
            return setting.Secured_Api_key__c;
    	} else {
    		return null;
    	}											 	
    }        
}