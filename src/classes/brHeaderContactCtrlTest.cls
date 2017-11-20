
@IsTest
private class brHeaderContactCtrlTest {
    static testMethod void getPhoneList() {

        List<brPhoneSupportList__c> newSettings = new List<brPhoneSupportList__c>();
        newSettings.add(new brPhoneSupportList__c(
                Name = 'TEST1',
                Country__c = 'TEST1',
                Order__c = 900,
                Phone__c = '1212121221'
        ));
        newSettings.add(new brPhoneSupportList__c(
                Name = 'TEST2',
                Country__c = 'TEST2',
                Order__c = 901,
                Phone__c = '21212121222'
        ));
        insert newSettings;

        Test.startTest();
        List<brPhoneSupportList__c> items = brHeaderContactCtrl.getPhoneList();
        Test.stopTest();

        System.assertNotEquals(null, items);
        System.assertEquals(2, items.size());
    }
}