@isTest
private class BrEventTriggerTest {

    @isTest
    static void testSaveEvents() {
        BrEventTestUtils.testCreateEvents();
        BrEventTestUtils.testCreateUser();
        User user = [SELECT Id, Name FROM User WHERE UserName = 'company@testorg.com'];

        System.runAs(user) {
            List<BR_Event__c> events = [SELECT Id FROM BR_Event__c LIMIT  150];
            System.assertEquals(3, events.size(), 'result contains events');
        }
    }

    @isTest
    static void testChangeStartDateWithReminders() {
        List<BR_Participation__c> participations = BrEventTestUtils.testCreateEventWithParticipations(false);

        DateTime updatedStartDate = DateTime.now();
        BR_Event__c updatedEvent = new BR_Event__c (Id = participations[0].BR_Event__c, Name = 'testEvent',
        Start_Date__c = updatedStartDate, Send_reminders__c = true);

        Test.startTest();
        update updatedEvent;
        Test.stopTest();

        System.assertEquals(updatedStartDate, updatedEvent.Start_Date__c, 'result should contain new start date');
        System.assertEquals(true, updatedEvent.Send_reminders__c, 'result should contain true value');
    }

    @isTest
    static void testChangeStartDateWithoutReminders() {
        List<BR_Participation__c> participations = BrEventTestUtils.testCreateEventWithParticipations(false);

        DateTime updatedStartDate = DateTime.now();
        BR_Event__c updatedEvent = new BR_Event__c (Id = participations[0].BR_Event__c, Name = 'testEvent', Start_Date__c = updatedStartDate);

        Test.startTest();
        update updatedEvent;
        Test.stopTest();

        System.assertEquals(updatedStartDate, updatedEvent.Start_Date__c, 'result should contain new start date');
        System.assertEquals(false, updatedEvent.Send_reminders__c, 'result should contain false value');
    }

    @isTest
    static void testWithoutChangeStartDateWithReminders() {
        List<BR_Participation__c> participations = BrEventTestUtils.testCreateEventWithParticipations(false);
        DateTime startDate = [SELECT Id, Start_Date__c FROM BR_Event__c
        WHERE Id = :participations[0].BR_Event__c].Start_Date__c;

        BR_Event__c updatedEvent = new BR_Event__c (Id = participations[0].BR_Event__c, Name = 'testEvent',
        Send_reminders__c = true, Start_Date__c = startDate);

        Test.startTest();
        update updatedEvent;
        Test.stopTest();

        System.assertEquals(startDate, updatedEvent.Start_Date__c, 'result should contain original start date');
        System.assertEquals(true, updatedEvent.Send_reminders__c, 'result should contain false value');
    }

    @isTest
    static void testWithoutChangeStartDateWithoutReminders() {

        Test.startTest();
        List<BR_Participation__c> participations = BrEventTestUtils.testCreateEventWithParticipations(false);
        Test.stopTest();

        List<BR_Event__c> event = [SELECT Id, Start_Date__c, Send_reminders__c FROM BR_Event__c
        WHERE Id = :participations[0].BR_Event__c LIMIT 150];

        System.assertNotEquals(null, event[0].Start_Date__c, 'result should contain not null start date');
        System.assertEquals(false, event[0].Send_reminders__c, 'result should contain false');
    }
}