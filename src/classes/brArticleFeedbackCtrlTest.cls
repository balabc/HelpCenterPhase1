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
    static void testHasVoteForArticle() {
        KnowledgeArticleVersion knowledgeArticle = [
                SELECT KnowledgeArticleId
                FROM KnowledgeArticleVersion
                LIMIT 1
        ];

        insert new PKB_Article_Feedback_Deflection__c(Session_ID__c = 'vahhso8g-l24e-rwhz-91xt-dyc3uv89du',
        Article_ID__c = knowledgeArticle.KnowledgeArticleId);

        Test.startTest();

        Boolean hasVote = brArticleFeedbackCtrl.hasVoteForArticle('vahhso8g-l24e-rwhz-91xt-dyc3uv89du', knowledgeArticle.KnowledgeArticleId);

        Test.stopTest();

        System.assertEquals(true, hasVote, 'vote not exist for current session');
    }

    @isTest
    static void testHasNotVoteForArticle() {
        KnowledgeArticleVersion knowledgeArticle = [
                SELECT KnowledgeArticleId
                FROM KnowledgeArticleVersion
                LIMIT 1
        ];

        insert new PKB_Article_Feedback_Deflection__c(Session_ID__c = 'vahhso8g-l24e-rwhz-91xt-dyc3uv89du',
        Article_ID__c = knowledgeArticle.KnowledgeArticleId);

        Test.startTest();

        Boolean hasVote = brArticleFeedbackCtrl.hasVoteForArticle('vahhso8g-l24e-rwhz-91xt-dyc3uv89aa', null);

        Test.stopTest();

        System.assertEquals(false, hasVote, 'vote exist for current session');
    }

    @isTest
    static void testGetFeedbackReasons() {
        Test.startTest();

        List<String> reasons = brArticleFeedbackCtrl.getFeedbackReasons();

        Test.stopTest();

        System.assertEquals('Test', reasons[0], 'empty list');
    }

    @isTest
    static void testAddPositiveFeedBackForArticle() {
        KnowledgeArticleVersion knowledgeArticle = [
                SELECT KnowledgeArticleId, Title, ArticleNumber
                FROM KnowledgeArticleVersion
                LIMIT 1
        ];

        Map<String,String> articleFields = new Map<String, String> {
                'articleId' => knowledgeArticle.KnowledgeArticleId,
                'articleTitle' => knowledgeArticle.Title,
                'articleNumber'=> knowledgeArticle.ArticleNumber,
                'author'=> null,
                'articleCreatedById'=> null,
                'lastPublishedDate'=> '2017-12-26T16:35:56.000Z',
                'lastModifiedById'=> null,
                'isVisibleInApp'=> 'true',
                'isVisibleInPkb'=>'false',
                'articleCaseAttachCount'=> '3'
        };

        Test.startTest();

        brArticleFeedbackCtrl.addPositiveFeedBackForArticle(articleFields,'vahhso8g-abcd-abcd-91xt-dyc3uv89du');

        Test.stopTest();

        List<PKB_Article_Feedback_Deflection__c> afdAfterInsert = [
                SELECT Id
                FROM PKB_Article_Feedback_Deflection__c
                WHERE Session_ID__c = :'vahhso8g-abcd-abcd-91xt-dyc3uv89du'
        ];

        System.assertEquals(1, afdAfterInsert.size(), 'article feedback deflection did not save');
    }

    @isTest
    static void testAddNegativeFeedbackForArticle() {
        KnowledgeArticleVersion knowledgeArticle = [
                SELECT KnowledgeArticleId, Title, ArticleNumber
                FROM KnowledgeArticleVersion
                LIMIT 1
        ];

        Map<String,String> articleFields = new Map<String, String> {
                'articleId' => knowledgeArticle.KnowledgeArticleId,
                'articleTitle' => knowledgeArticle.Title,
                'articleNumber'=> knowledgeArticle.ArticleNumber,
                'author'=> null,
                'articleCreatedById'=> null,
                'lastPublishedDate'=> '2017-12-26T16:35:56.000Z',
                'lastModifiedById'=> null,
                'isVisibleInApp'=> 'true',
                'isVisibleInPkb'=>'false',
                'articleCaseAttachCount'=> '3'
        };

        Test.startTest();

        brArticleFeedbackCtrl.addNegativeFeedbackForArticle(articleFields, 'Test comment', '', 'vahhso8g-test-test-91xt-dyc3uv89du');

        Test.stopTest();

        List<PKB_Article_Feedback_Deflection__c> afdAfterInsert = [
                SELECT Id
                FROM PKB_Article_Feedback_Deflection__c
                WHERE Session_ID__c = :'vahhso8g-test-test-91xt-dyc3uv89du'
        ];

        System.assertEquals(1, afdAfterInsert.size(), 'article feedback deflection did not save');
    }
}