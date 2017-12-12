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
        /*System.debug('222222222' + article2);
        System.debug('3333333333' + 'SELECT KnowledgeArticleId, Title, Nav_Title__c, Section_Anchors__c, id, Sort_Oder_in_Category__c FROM ' + c + ' WHERE PublishStatus = \'Online\' ORDER BY Sort_Oder_in_Category__c ASC');
        List<sObject> articles = Database.query('SELECT KnowledgeArticleId, Title, Nav_Title__c, Section_Anchors__c, id, Sort_Oder_in_Category__c FROM ' + article2.ArticleType + ' WHERE PublishStatus = \'Online\' ORDER BY Sort_Oder_in_Category__c ASC');
        System.debug('1111111test' + articles);*/

        brCategoriesController.getCatalog(article.id, 'Learning__kav', tempCat.DataCategoryGroupName);
        brCategoriesController.getCatalog(article2.id, 'Public__kav', tempCat1.DataCategoryGroupName);
        Test.stopTest();
    }

}