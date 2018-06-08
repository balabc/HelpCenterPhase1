public with sharing class brBlogArticleWrapper {
    @AuraEnabled
    public brBlog_article__c item {get; set;}

    @AuraEnabled
    public List<brBlog_Category__c> categories {get; set;}

    @AuraEnabled
    public List<brBlog_Tag__c> tags {get; set;}

    @AuraEnabled
    public Integer commentsNumber {get; set;}

    @AuraEnabled
    public String  profilePhotoUrl {get; set;}
}