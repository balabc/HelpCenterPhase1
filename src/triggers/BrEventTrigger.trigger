trigger BrEventTrigger on BR_Event__c (before update) {
    BrEventTriggerHandler handler = new BrEventTriggerHandler();

    if (Trigger.isUpdate && Trigger.isBefore) {
        handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}