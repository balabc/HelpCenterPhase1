trigger brIdeaTrigger on Idea (after insert, after update) {
    try {
        brIdeaTriggerHandler hndlr = new brIdeaTriggerHandler();

        if (Trigger.isAfter && Trigger.isInsert) {
            hndlr.createSubscriptions(Trigger.new);
        }
        if (Trigger.isAfter && Trigger.isInsert) {
            hndlr.sendNewIdeaNotifications(Trigger.new);
        } else if (Trigger.isAfter && Trigger.isUpdate) {
            hndlr.sendStatusChangeNotifications(Trigger.new, Trigger.oldMap);
        }
    } catch(Exception ex) {
        System.debug('IdeaTrigger error: ' + ex.getMessage());
    }
}