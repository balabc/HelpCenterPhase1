@IsTest
private class brGuidesListCtrlTest {

    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void testGetGuideArticles() {
        Test.startTest();

        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {

            DescribeDataCategoryGroupResult[] results = Schema.describeDataCategoryGroups(
                    new String[]{
                            'KnowledgeArticleVersion'
                    }
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


            List<brGuideItem__mdt> guideItems = brGuidesListCtrl.getGuideArticles();
            brGuidesListCtrl.getCountForEachCategory();

            System.assertEquals(3, guideItems.size(), 'wrong number of guide articles');
        }

        Test.stopTest();
    }

}