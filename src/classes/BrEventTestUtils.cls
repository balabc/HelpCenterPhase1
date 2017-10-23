@isTest
public with sharing class BrEventTestUtils {

    public static void testCreateUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User user = new User(Alias = 'standt', Email='company@testorg.com',
                EmailEncodingKey='UTF-8', FirstName='Test', LastName='Testing', LanguageLocaleKey='en_US',
                Department = 'G&A - Engineering', Country ='Italy', CompanyName ='Varonis France SAS',
                LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='company@testorg.com');
        insert user;

        System.assertEquals('company@testorg.com', user.Username, 'get user name value');
    }

    public static List<BR_Event__c> testCreateEvents() {
        List<BR_Event__c> events = new List<BR_Event__c>();
        DateTime startDate = DateTime.now();

        for (Integer i = 0; i < 3; i++) {
            events.add(new BR_Event__c(Name = 'Event' + i, Start_Date__c = startDate));
        }

        insert events;

        System.assertEquals('Event0', events[0].Name, 'get first event name value');

        return events;
    }

    public static List<BR_Participation__c> testCreateEventWithParticipations(Boolean reminder) {
        DateTime startDate = DateTime.now();
        BR_Event__c event = new BR_Event__c(Name = 'testEvent', Start_Date__c = startDate,
                Send_reminders__c = reminder);

        insert event;

        List<BR_Participation__c> participations = new List<BR_Participation__c>();

        for (Integer i = 0; i < 2; i++) {
            participations.add(new BR_Participation__c(TriggerSendReminderWorkflow__c = true,
                    BR_Event__c = event.Id, Participate__c = 'Yes'));
        }

        insert participations;

        return participations;
    }
}