public with sharing class brBlogArticleTriggerHandler {
	public brBlogArticleTriggerHandler() {}

    public void onBeforeInsertAndUpdate(List<brBlog_article__c> newArticle) {

        if ( (newArticle.get(0).Draft__c == false) &&
             (newArticle.get(0).Published_Date__c == null)) {

            newArticle.get(0).Published_Date__c = DateTime.now();
        }
    }
}