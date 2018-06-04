@isTest
private class brCategoriesTest {

    @isTest
    static void tMethod() {
        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
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

            List<Public__kav> pubList = [SELECT KnowledgeArticleId, UrlName FROM Public__kav WHERE Id = :article2.Id];
            List<Learning__kav> gdList = [SELECT KnowledgeArticleId, UrlName FROM Learning__kav WHERE Id = :article1.Id];
            brCategoriesController.getCatalog('Learning__kav');
            brCategoriesController.getCatalog('Public__kav');
            brCategoriesController.getArticleSectionsByArticle(article2.Id);
        }
        Test.stopTest();
    }

}