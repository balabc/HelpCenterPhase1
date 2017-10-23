@isTest
public with sharing class EventStartDateCtrlTest {
    static testMethod void testGetStartDateFormatted() {
        DateTime startDate = DateTime.now();
        BR_Event__c event = new BR_Event__c(Name = 'testEvent', Start_Date__c = startDate
        );

        insert event;

        BrEventStartDateCtrl ctrl = new BrEventStartDateCtrl();
        ctrl.startDate = event.Start_Date__c;
        ctrl.timezone = 'Europe/Minsk';
        ctrl.locale = 'be_BY';

        System.assertNotEquals('28.04.2017 21:18', ctrl.getStartDateFormatted(), 'Formatted start date for event');
    }
}