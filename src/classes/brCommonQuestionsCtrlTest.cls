@IsTest
private class brCommonQuestionsCtrlTest {

    @TestSetup
    static void setup() {
        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

        Test.stopTest();
    }

    @isTest
    static void getArticles_Negative() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            List<Public__kav> kArticles = brCommonQuestionsCtrl.getArticles();
            System.assertNotEquals(null, kArticles);
            System.assertEquals(0, kArticles.size());
        }

        Test.stopTest();

    }

    @isTest
    static void getArticles_Positive() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];
        Test.startTest();

        System.runAs(testUser) {
            Public__kav a = new Public__kav(Title = 'Hello', UrlName = 'hello', Summary = 'SomeSummaryText', IsVisibleInPkb = true);
            insert a;
            System.assertNotEquals(null, a.id);

            a = [SELECT KnowledgeArticleId FROM Public__kav WHERE Id = :a.Id];
            System.assertNotEquals(null, a.KnowledgeArticleId);

            KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);

            List<Public__kav> kArticles = brCommonQuestionsCtrl.getArticles();

            System.assertNotEquals(null, kArticles);
            System.assertEquals(1, kArticles.size());
        }

        Test.stopTest();

    }
}