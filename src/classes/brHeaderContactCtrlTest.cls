@IsTest
private class brHeaderContactCtrlTest {
    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void getPhoneList() {

        Test.startTest();

        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {

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

            List<brPhoneSupportList__c> items = brHeaderContactCtrl.getPhoneList();
            new brHeaderContactCtrl.applicationException();
        }
        Test.stopTest();
    }
}