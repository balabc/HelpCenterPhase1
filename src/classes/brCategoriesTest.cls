@isTest
private class brCategoriesTest {
    static testMethod void tMethod() {
        Knowledge__kav a = new Knowledge__kav(
            Title = 'test apex',
            UrlName = 'testapex'
        );       
        insert a;   
        a = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id = :a.Id];
        KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);
        Test.startTest();
        Map<String,String> mapcat = brCategorySevice.getAllCategoriesMap('All');
        brCategoriesController.getCatalog(a.KnowledgeArticleId);
        Test.stopTest();
    }      
}