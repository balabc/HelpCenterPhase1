public with sharing class BrEventTriggerHandler {
    public BrEventTriggerHandler() {}

    public void onBeforeUpdate(BR_Event__c[] changedEvents, Map<Id, BR_Event__c > oldMapEvents) {
        Set<Id> eventIds = new Set<Id>();

        for (BR_Event__c event : changedEvents) {
            BR_Event__c oldEvent = oldMapEvents.get(event.Id);

            if (oldEvent.Start_Date__c != event.Start_Date__c || oldEvent.Send_reminders__c != event.Send_reminders__c) {
                eventIds.add(event.Id);
            }
            else {
                return;
            }
        }

        BrEventsHelper.updateParticipateOnChangeEventDate(eventIds);
    }
}