@IsTest
private class BrEventsHelperTest {

    static testMethod void testPerformAccessCheck() {

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User user = new User(Alias = 'testusr1', Email='testusr1@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey = UserInfo.getTimeZone().getID(), UserName='testusr1@testorg.com');

        insert user;

        System.runAs(user){

            System.assertEquals(false, BrEventsHelper.performAccessCheck('read', 'BR_Event__c', null), 'insufficient user permisssions');
            System.assertEquals(false, BrEventsHelper.performAccessCheck('read', 'BR_Participation__c', null), 'insufficient user permisssions');
            System.assertEquals(false, BrEventsHelper.performAccessCheck('edit', 'BR_Participation__c', null), 'insufficient user permisssions');
            System.assertEquals(false, BrEventsHelper.performAccessCheck('create', 'BR_Participation__c', null), 'insufficient user permisssions');
            List<String> participationFieldsToRead = new List<String>();
            participationFieldsToRead.add('Participate__c');
            System.assertEquals(false, BrEventsHelper.performAccessCheck('read', 'BR_Participation__c', participationFieldsToRead), 'insufficient user permisssions');
            List<String> participationFieldsToUpdate = new List<String>();
            participationFieldsToUpdate.add('Participate__c');
            System.assertEquals(false, BrEventsHelper.performAccessCheck('edit', 'BR_Participation__c', participationFieldsToUpdate), 'insufficient user permisssions');
            List<String> participationFieldsToCreate = new List<String>();
            participationFieldsToCreate.add('BR_Event__c');
            System.assertEquals(false, BrEventsHelper.performAccessCheck('create', 'BR_Participation__c', participationFieldsToCreate), 'insufficient user permisssions');
        }
    }
}