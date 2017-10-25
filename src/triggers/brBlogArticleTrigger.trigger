trigger brBlogArticleTrigger on brBlog_article__c (before insert, before update) {

    brBlogArticleTriggerHandler handler = new brBlogArticleTriggerHandler();
    
    if ((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore)) {
        handler.onBeforeInsertAndUpdate(Trigger.new);
    }
}