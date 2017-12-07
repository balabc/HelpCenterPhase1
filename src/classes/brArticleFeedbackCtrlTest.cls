@IsTest
private class brArticleFeedbackCtrlTest {
    @TestSetup
    static void setup() {
        University__kav article = new University__kav(Title = 'Test', UrlName = 'test', Short_Description__c = 'Test');

        insert article;

        for (University__kav uKav : [SELECT KnowledgeArticleId FROM University__kav WHERE Id = :article.Id]) {
            KbManagement.PublishingService.publishArticle(uKav.KnowledgeArticleId, true);
        }
    }

    @isTest
    static void testGetUserType() {
        Test.startTest();

        String userType = brArticleFeedbackCtrl.getUserType();

        Test.stopTest();

        System.assertEquals('Standard', userType, 'result without type of user');
    }

    @isTest
    static void testHasVoteForArticle() {
        String articleId = [SELECT KnowledgeArticleId FROM KnowledgeArticleVersion].KnowledgeArticleId;
        insert new Vote(ParentId = articleId, Type = 'Up');

        Test.startTest();

        Boolean hasVote = brArticleFeedbackCtrl.hasVoteForArticle(articleId);

        Test.stopTest();

        System.assertEquals(true, hasVote, 'vote not exist for current user');
    }

    @isTest
    static void testHasNotVoteForArticle() {
        String articleId = [SELECT KnowledgeArticleId FROM KnowledgeArticleVersion].KnowledgeArticleId;

        Test.startTest();

        Boolean hasVote = brArticleFeedbackCtrl.hasVoteForArticle(articleId);

        Test.stopTest();

        System.assertEquals(false, hasVote, 'vote exist for current user');
    }

    @isTest
    static void testGetFeedbackReasons() {
        Test.startTest();

        List<String> reasons = brArticleFeedbackCtrl.getFeedbackReasons();

        Test.stopTest();

        System.assertEquals('Test', reasons[0], 'empty list');
    }

    @isTest
    static void testAddVoteUpForArticle() {
        String articleId = [SELECT KnowledgeArticleId FROM KnowledgeArticleVersion].KnowledgeArticleId;

        Test.startTest();

        brArticleFeedbackCtrl.addVoteUpForArticle(articleId);

        Test.stopTest();

        List<Vote> votes = [SELECT Id FROM Vote WHERE ParentId = :articleId AND Type = 'Up'];

        System.assertEquals(1, votes.size(), 'vote did not save');
    }

    @isTest
    static void testAddVoteDownAndSaveReasonForArticle() {
        String articleId = [SELECT KnowledgeArticleId FROM KnowledgeArticleVersion].KnowledgeArticleId;

        Test.startTest();

        brArticleFeedbackCtrl.addVoteDownAndSaveReasonForArticle(articleId, 'Test');

        Test.stopTest();

        List<Vote> votes = [SELECT Id FROM Vote WHERE ParentId = :articleId AND Type = 'Down'];

        System.assertEquals(1, votes.size(), 'vote did not save');
    }
}