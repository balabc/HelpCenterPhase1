@isTest
private class brCategoriesTest {

    static testMethod void tMethod() {

        Learning__kav article = new Learning__kav(Title = 'Test', Nav_Title__c = 'Test', UrlName = 't321est');
        insert article;

        for (Learning__kav uKav : [SELECT KnowledgeArticleId FROM Learning__kav WHERE Id = :article.Id]) {
            KbManagement.PublishingService.publishArticle(uKav.KnowledgeArticleId, true);
        }

        Learning__kav article1 = new Learning__kav(Title = 'Test1', Nav_Title__c = 'Test', UrlName = 'te213st1');
        insert article1;

        for (Learning__kav uKav : [SELECT KnowledgeArticleId FROM Learning__kav WHERE Id = :article1.Id]) {
            KbManagement.PublishingService.publishArticle(uKav.KnowledgeArticleId, true);
        }

        Learning__DataCategorySelection tempCat = new Learning__DataCategorySelection();
        tempCat.DataCategoryGroupName = 'Guides';
        tempCat.DataCategoryName = 'Inventory_management';
        tempCat.ParentId = article.id;


        insert tempCat;

        Public__kav article2 = new Public__kav(Title = 'Test1', Nav_Title__c = 'Test', UrlName = 'tes231123312t1', Section_Anchors__c = 'asdsafds:sdfsdf;dsafasfd:sdfsdf;');
        insert article2;

        for (Public__kav uKav : [SELECT KnowledgeArticleId FROM Public__kav WHERE Id = :article2.Id]) {
            KbManagement.PublishingService.publishArticle(uKav.KnowledgeArticleId, true);
        }

        Public__DataCategorySelection tempCat1 = new Public__DataCategorySelection();
        tempCat1.DataCategoryGroupName = 'Public';
        tempCat1.DataCategoryName = 'Configure_Your_Store';
        tempCat1.ParentId = article2.id;

        insert tempCat1;

        Test.startTest();
        List<Public__kav> pubList = [SELECT KnowledgeArticleId, UrlName FROM Public__kav WHERE Id = :article2.Id];
        List<Learning__kav> gdList = [SELECT KnowledgeArticleId, UrlName FROM Learning__kav WHERE Id = :article1.Id];
        brCategoriesController.getCatalog(article.id, 'Learning__kav', tempCat.DataCategoryGroupName, gdList[0].UrlName);
        brCategoriesController.getCatalog(article2.id, 'Public__kav', tempCat1.DataCategoryGroupName, pubList[0].UrlName);
        brCategoriesCatalogServiceSelector.getArticleCategories('test');
        brCategoryServiceSelector.getCategories('Inventory_management');
        brCategoryServiceSelector.getFirstCategories('Inventory_management');
        brCategoryServiceSelector.getSubCategories('Inventory_management');
        brCategoryServiceSelector.getCategories('Payments');
        brCategoryServiceSelector.getFirstCategories('Payments');
        brCategoryServiceSelector.getSubCategories('Payments');
        brCategoryServiceSelector.getCategories('Live_Chat');
        brCategoryServiceSelector.getFirstCategories('Live_Chat');
        brCategoryServiceSelector.getSubCategories('Live_Chat');
        Test.stopTest();
    }

}