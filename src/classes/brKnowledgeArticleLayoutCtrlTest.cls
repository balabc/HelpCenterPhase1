
@IsTest
private class brKnowledgeArticleLayoutCtrlTest {
    static testMethod void testGetArticleTypeByUrlName() {

        Learning__kav article = new Learning__kav(Title = 'Test', Nav_Title__c = 'Test', UrlName = 't321est');
        insert article;

        for (Learning__kav uKav : [SELECT KnowledgeArticleId FROM Learning__kav WHERE Id = :article.Id]) {
            KbManagement.PublishingService.publishArticle(uKav.KnowledgeArticleId, true);
        }

        Test.startTest();
        System.assertEquals('Learning__kav', brKnowledgeArticleLayoutCtrl.getArticleTypeByUrlName('t321est'), 'should return specific article type');
        Test.stopTest();

    }
}