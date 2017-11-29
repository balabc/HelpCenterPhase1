@isTest
private class brCategoriesTest {
    static testMethod void tMethod() {
        Knowledge__kav a = new Knowledge__kav(
            Title = 'test apex',
            UrlName = 'testapex'
        );       
        insert a;   
        Knowledge__kav a2 = new Knowledge__kav(
            Title = 'test apex2',
            UrlName = 'testapex2',
            Nav_Title__c = 'new Title',
            Article_Sections__c = 'Into:Into;Adding_Currency:Adding Currency;Cha_Currency:Changint the Currency'
        );       
        insert a2;          
        a = [SELECT id, KnowledgeArticleId FROM Knowledge__kav WHERE Id = :a.Id];
        a2 = [SELECT id, KnowledgeArticleId FROM Knowledge__kav WHERE Id = :a2.Id];
        KbManagement.PublishingService.publishArticle(a.KnowledgeArticleId, true);
        KbManagement.PublishingService.publishArticle(a2.KnowledgeArticleId, true);
        Test.startTest();
        Map<String,String> mapcat = brCategorySevice.getAllCategoriesMap('All');
        brCategoriesController.getCatalog(a.id, 'Knowledge__kav', 'All');
        brCategoriesController.getCatalog(a2.id, 'Knowledge__kav', 'All');
        Test.stopTest();
    }      
}