public with sharing class brUserMenuCtrl {
    @AuraEnabled
    public static User getCurrentUser() {
        return [SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id = :userInfo.getUserId() LIMIT 1];
    }

    @AuraEnabled
    public static String getUserMenuItems() {
        return [SELECT Value__c FROM brCommunityMetadata__mdt].Value__c;
    }

}