
@IsTest
private class brCommonQuestionsCtrlTest {
    static testMethod void getArticles() {
/*
        Public__kav a = new Public__kav(Title='Hello',UrlName='hello');
        insert a;
        a = [SELECT KnowledgeArticleId FROM Public__kav WHERE Id = :a.Id];

        KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);
*/
        Test.startTest();
            List<Public__kav> kArticles = brCommonQuestionsCtrl.getArticles();
        Test.stopTest();

        System.assertNotEquals(null, kArticles);
        System.assertEquals(0, kArticles.size());//TODO:need to gen article to count them

    }
}