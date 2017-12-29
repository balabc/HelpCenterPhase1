@IsTest
private class brCommonQuestionsCtrlTest {

    static testMethod void getArticles_Negative() {

        Test.startTest();
            List<Public__kav> kArticles = brCommonQuestionsCtrl.getArticles();
        Test.stopTest();

        System.assertNotEquals(null, kArticles);
        System.assertEquals(0, kArticles.size());

    }

    static testMethod void getArticles_Positive() {

        Public__kav a = new Public__kav(Title='Hello',UrlName='hello',Summary='SomeSummaryText',IsVisibleInPkb=true);
        insert a;
        a = [SELECT KnowledgeArticleId FROM Public__kav WHERE Id = :a.Id];

        System.assertNotEquals(null, a.id);
        System.assertNotEquals(null, a.KnowledgeArticleId);

        Test.startTest();
            KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);
            List<Public__kav> kArticles = brCommonQuestionsCtrl.getArticles();
        Test.stopTest();

        System.assertNotEquals(null, kArticles);
        System.assertEquals(1, kArticles.size());

    }
}