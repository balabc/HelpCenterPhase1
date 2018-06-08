
@IsTest
private class brKnowledgeArticleLayoutCtrlTest {
    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @IsTest
    static void testGetArticleTypeByUrlName() {
        Test.startTest();

        User user = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', user.UserName, 'wrong username');

        System.runAs(user) {

            Learning__kav article = new Learning__kav(Title = 'Test', Nav_Title__c = 'Test', UrlName = 't321est');
            insert article;

            for (Learning__kav uKav : [SELECT KnowledgeArticleId FROM Learning__kav WHERE Id = :article.Id]) {
                KbManagement.PublishingService.publishArticle(uKav.KnowledgeArticleId, true);
            }

            System.assertEquals('Learning__kav', brKnowledgeArticleLayoutCtrl.getArticleTypeByUrlName('t321est'), 'should return specific article type');
        }

        Test.stopTest();

    }
}