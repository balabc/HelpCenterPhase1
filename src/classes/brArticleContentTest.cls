@isTest
private class brArticleContentTest {

    static testMethod void tGetDataForArticle() {

        DescribeDataCategoryGroupResult[] results = Schema.describeDataCategoryGroups(
                new String[] { 'KnowledgeArticleVersion'}
        );

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

        Public__kav article2 = new Public__kav(Title = 'Test1', Nav_Title__c = 'Test', UrlName = 'tes231123312t1');
        insert article2;

        University__kav article3 = new University__kav(Title = 'Test1', Nav_Title__c = 'Test', UrlName = 'tes231123123213123123t1');
        insert article3;

        brArticleModel am = new brArticleModel();
        am.id = 'as4ewa4sad4';
        am.articleType = 'as4dsa4';
        am.articleSections = 'asd4s4d';
        am.active = true;
        am.title = 'as4a4';
        am.categories = new Set<String>();

        Test.startTest();

        String m = brArticleContentController.getArticleType(article.id);
        brArticleModel m1 = brArticleContentController.getArticleContent(article1.id);
        brArticleModel m3 = brArticleContentController.getArticleContent(article2.id);
        brArticleModel m4 = brArticleContentController.getArticleContent(article3.id);
        List<SObject> m2 = brArticleContentController.getListArticleInCurrentCategory(article.id);
        Map<String, Integer> m23 = brArticleContentController.getCountForEachCategory('Learning__kav');
        String test123 = brArticleContentServiceSelector.getArticleByUrlKnowledgeArticleId('t321est', 'Learning__kav');

        brArticleContentServiceSelector.getDataCategoryByArticleTypeAndId('test', 'test');
        brArticleContentServiceSelector.getArticleById('test');
        brArticleContentServiceSelector.getDataCategoryNameByArticleId('test', 'test');
        brArticleContentServiceSelector.getArticleByUrl('test', 'test');
        brArticleContentServiceSelector.getArticleByUrlKnowledgeArticleId('test', 'test');
        brArticleContentServiceSelector.getArticleListInDataCategory('test');
        brArticleContentServiceSelector.getAllArticleByArticleType('test');
        brArticleContentServiceSelector.getArticleListByDataCategory('test', new List<String>());

        Test.stopTest();
    }

}