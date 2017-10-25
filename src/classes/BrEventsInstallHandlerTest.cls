@IsTest
private class BrEventsInstallHandlerTest {
    static testMethod void testOnInstall1() {
        BrEventsInstallHandler installHandler = new BrEventsInstallHandler();
        Test.testInstall(installHandler, null);

        List<BrEvents_Settings__c> settings = [SELECT Value__c FROM BrEvents_Settings__c WHERE Name = 'image source' LIMIT 1];

        if (settings.size() == 1) {
            System.assertEquals(settings[0].Value__c, 'files', 'Invalid value');
        }
        else {
            System.assertEquals(false, true, 'Settings value has not been created');
        }
    }

    static testMethod void testOnInstall2() {
        BrEventsInstallHandler installHandler = new BrEventsInstallHandler();
        Test.testInstall(installHandler, new Version(1,0));

        List<BrEvents_Settings__c> settings = [SELECT Value__c FROM BrEvents_Settings__c WHERE Name = 'image source' LIMIT 1];

        if (settings.size() == 1) {
            System.assertEquals(settings[0].Value__c, 'attachments', 'Invalid value');
        }
        else {
            System.assertEquals(false, true, 'Settings value has not been created');
        }
    }
}