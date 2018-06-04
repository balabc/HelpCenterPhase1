@IsTest
private class brBlogArticleWrapperTest {
    @isTest
    static void testBehavior() {
        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
            brBlogArticleWrapper wrapper = new brBlogArticleWrapper();
            wrapper.item = new brBlog_article__c();
            wrapper.categories = new List<brBlog_Category__c>();
            wrapper.tags = new List<brBlog_Tag__c>();
            wrapper.commentsNumber = 0;
            wrapper.profilePhotoUrl = '';
        }

        Test.stopTest();
    }
}