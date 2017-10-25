trigger brBlogCategoryTrigger on brBlog_Category__c (before insert, before update) {

	brBlogCategoryTriggerHandler handler = new brBlogCategoryTriggerHandler();
	
	if (Trigger.isInsert && Trigger.isBefore) {
		handler.onBeforeInsert(Trigger.new);
	}
	
	else if (Trigger.isUpdate && Trigger.isBefore) {
		handler.onBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap);
	}
}