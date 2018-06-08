@IsTest
private class brFeaturedArticlesCtrlTest {

    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void testGetArticles() {
        Test.startTest();

        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
            List<Public__kav> featuredArticles = new List<Public__kav>();

            for (Integer i = 0; i < 5; i++) {
                featuredArticles.add(new Public__kav(Title = 'Test' + i, IsVisibleInPkb = true, UrlName = 'TestUrl' + i));
            }

            insert featuredArticles;

            List<Id> articlesId = new List<Id>();

            for (Public__kav vKav : featuredArticles) {
                articlesId.add(vKav.Id);
            }

            for (Public__kav article : [SELECT KnowledgeArticleId FROM Public__kav WHERE Id IN :articlesId]) {
                KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);
            }

            List<Public__kav> featuredItems = brFeaturedArticlesCtrl.getArticles(3);
            System.assertEquals(3, featuredItems.size(), 'wrong number of featured articles');
        }

        Test.stopTest();

    }
}