trigger brIdeaCommentTrigger on IdeaComment (after insert) {
    try {
        brIdeaCommentTriggerHandler hndlr = new brIdeaCommentTriggerHandler();

        if(Trigger.isAfter && Trigger.isInsert) {
            hndlr.sendNotificationsToSubscribers(Trigger.new);
            hndlr.sendNotificationsToAssignedUsers(Trigger.new);
        }
    } catch(Exception ex) {
        System.debug('IdeaCommentTrigger error: ' + ex.getMessage());
    }
}