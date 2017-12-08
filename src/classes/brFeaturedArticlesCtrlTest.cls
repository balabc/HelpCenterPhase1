@IsTest
private class brFeaturedArticlesCtrlTest {
    @isTest
    static void testGetArticles() {
        List<Public__kav> featuredArticles = new List<Public__kav>();

        for (Integer i = 0; i < 10; i++) {
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

        Test.startTest();

        List<Public__kav> featuredItems = brFeaturedArticlesCtrl.getArticles(8);

        Test.stopTest();

        System.assertEquals(8, featuredItems.size(), 'wrong number of featured articles');
    }
}