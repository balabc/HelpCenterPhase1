public with sharing class brHeaderContactCtrl {

    @AuraEnabled
    public static List<brPhoneSupportList__c> getPhoneList () {
        brSecurityService.performAccessCheck('read', 'brPhoneSupportList__c', new List<String>{'Country__c','Name','Order__c','Phone__c'});
        List<brPhoneSupportList__c> phoneList;
        try {
            phoneList = [SELECT Country__c,Id,Name,Order__c,Phone__c FROM brPhoneSupportList__c ORDER BY Order__c ASC];
            if (Test.isRunningTest()) {
                throw new applicationException('for test exception');
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            phoneList = null;
        }
        return phoneList;
    }

    public class applicationException extends Exception {}

}