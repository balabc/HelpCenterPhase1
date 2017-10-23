@IsTest
private class BrEventsSettingsCtrlTest {
    static testMethod void testAll() {
        BrEventsSettingsCtrl ctrlObj1 = new BrEventsSettingsCtrl();

        System.assertEquals(true, ctrlObj1.imageSourceOptions.size() > 0, 'Invalid options number');

        PageReference pageRefRes1 = ctrlObj1.saveSettings();

        System.assertEquals(null, pageRefRes1, 'Method should return null');

        insert new BrEvents_Settings__c(Name='image source', Label__c = 'Image Source', Value__c = 'files');

        BrEventsSettingsCtrl ctrlObj2 = new BrEventsSettingsCtrl();

        ctrlObj2.selectedImageSource = 'attachments';
        PageReference pageRefRes2 = ctrlObj2.saveSettings();

        System.assertNotEquals(null, pageRefRes2, 'Method should return PageReference instance');

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User user = new User(Alias = 'testusr1', Email='testusr1@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey = UserInfo.getTimeZone().getID(), UserName='testusr1@testorg.com');

        insert user;

        System.runAs(user){
            ctrlObj2.selectedImageSource = 'files';
            PageReference pageRefRes3 = ctrlObj2.saveSettings();

            System.assertNotEquals(null, pageRefRes3, 'Method should return PageReference instance');
        }
    }
}