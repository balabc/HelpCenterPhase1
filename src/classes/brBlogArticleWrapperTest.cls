@IsTest
private class brBlogArticleWrapperTest {
    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void testBehavior() {
        Test.startTest();

        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

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