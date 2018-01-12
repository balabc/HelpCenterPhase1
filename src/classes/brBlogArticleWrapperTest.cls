@IsTest
private class brBlogArticleWrapperTest {
    static testMethod void testBehavior() {
        brBlogArticleWrapper wrapper = new brBlogArticleWrapper();
        wrapper.item = new brBlog_article__c();
        wrapper.categories = new List<brBlog_Category__c>();
        wrapper.tags = new List<brBlog_Tag__c>();
        wrapper.commentsNumber = 0;
        wrapper.profilePhotoUrl = '';
    }
}