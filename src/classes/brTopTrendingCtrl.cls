public with sharing class brTopTrendingCtrl {
    @AuraEnabled
    public static Id getChatterGroupListId() {
    	return brChatterGroupService.getListId();
    }	
    @AuraEnabled
    public static List<brChatterGroupModel> getChatterGroupByStringId(String ids) {
    	return brChatterGroupService.getChatterGroupByStringId(ids);
    }
    @AuraEnabled
    public static List<brFeedItemModel> getQuestions() {
    	return brFeedItemService.getQuestions();
    }    
    @AuraEnabled
    public static List<brBlogArticleWrapper> getBlogArticles() {
    	List<brBlogArticleWrapper> articleWrappers  = new List<brBlogArticleWrapper>();
    	List<brBlog_article__c> articles = [SELECT id, Name FROM brBlog_article__c WHERE Published__c = true ORDER BY Published_Date__c ASC limit 4];
    	for(brBlog_article__c art : articles) {
    		brBlogArticleWrapper cls = new brBlogArticleWrapper();
    		cls.item = art;
    		articleWrappers.add(cls);
    	}
    	return articleWrappers;
    }
}