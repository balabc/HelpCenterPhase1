trigger brBlogTagsTrigger on brBlog_Tag__c (before insert, before update) {

    brBlogTagsTriggerHandler handler = new brBlogTagsTriggerHandler();
    
    if (Trigger.isInsert && Trigger.isBefore) {
        handler.onBeforeInsert(Trigger.new);
    }
    
    else if (Trigger.isUpdate && Trigger.isBefore) {
        handler.onBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap);
    }
}