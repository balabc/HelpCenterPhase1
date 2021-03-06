@IsTest
private class brVideosListCtrlTest {
    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void testGetVideoArticles() {
        Test.startTest();

        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {


            List<University__kav> videoArticles = new List<University__kav>();

            for (Integer i = 1; i < 4; i++) {
                videoArticles.add(new University__kav(Title = 'Test', UrlName = 'test' + i, Short_Title__c = 'Test video article' + i, Short_Description__c = 'Test',
                        Video_Duration__c = '5:02', Sort_Order__c = 4 - i));
            }

            insert videoArticles;

            List<Id> articlesId = new List<Id>();

            for (University__kav vKav : videoArticles) {
                articlesId.add(vKav.Id);
            }

            for (University__kav article : [SELECT KnowledgeArticleId FROM University__kav WHERE Id IN :articlesId]) {
                KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);
            }

            List<University__kav> videoItems = brVideosListCtrl.getVideoArticles();
            System.assertEquals(3, videoItems.size(), 'wrong number of video articles');
            System.assertEquals('Test video article3', videoItems[0].Short_Title__c, 'wrong sorting of video articles');
            System.assertEquals('Test video article2', videoItems[1].Short_Title__c, 'wrong sorting of video articles');
            System.assertEquals('Test video article1', videoItems[2].Short_Title__c, 'wrong sorting of video articles');
        }

        Test.stopTest();

    }
}