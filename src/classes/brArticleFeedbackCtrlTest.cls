@IsTest
private class brArticleFeedbackCtrlTest {
    @TestSetup
    static void setup() {
        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
            University__kav article = new University__kav(Title = 'Test', UrlName = 'test', Short_Description__c = 'Test');

            insert article;

            for (University__kav uKav : [SELECT KnowledgeArticleId FROM University__kav WHERE Id = :article.Id]) {
                KbManagement.PublishingService.publishArticle(uKav.KnowledgeArticleId, true);
            }
        }

        Test.stopTest();
    }

    @isTest
    static void testHasVoteForArticle() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {

            KnowledgeArticleVersion knowledgeArticle = [
                    SELECT KnowledgeArticleId
                    FROM KnowledgeArticleVersion
                    LIMIT 1
            ];

            insert new PKB_Article_Feedback_Deflection__c(Session_ID__c = 'vahhso8g-l24e-rwhz-91xt-dyc3uv89du',
            Article_ID__c = knowledgeArticle.KnowledgeArticleId);

            Boolean hasVote = brArticleFeedbackCtrl.hasVoteForArticle('vahhso8g-l24e-rwhz-91xt-dyc3uv89du', knowledgeArticle.KnowledgeArticleId);
            System.assertEquals(true, hasVote, 'vote not exist for current session');
        }

        Test.stopTest();

    }

    @isTest
    static void testHasNotVoteForArticle() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {

            KnowledgeArticleVersion knowledgeArticle = [
                    SELECT KnowledgeArticleId
                    FROM KnowledgeArticleVersion
                    LIMIT 1
            ];

            insert new PKB_Article_Feedback_Deflection__c(Session_ID__c = 'vahhso8g-l24e-rwhz-91xt-dyc3uv89du',
            Article_ID__c = knowledgeArticle.KnowledgeArticleId);
            Boolean hasVote = brArticleFeedbackCtrl.hasVoteForArticle('vahhso8g-l24e-rwhz-91xt-dyc3uv89aa', null);
            System.assertEquals(false, hasVote, 'vote exist for current session');
        }

        Test.stopTest();

    }

    @isTest
    static void testGetFeedbackReasons() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            List<String> reasons = brArticleFeedbackCtrl.getFeedbackReasons();
            System.assertEquals('Test', reasons[0], 'empty list');
        }

        Test.stopTest();

    }

    @isTest
    static void testAddPositiveFeedBackForArticle() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

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

        System.runAs(testUser) {
            brArticleFeedbackCtrl.addPositiveFeedBackForArticle(articleFields, 'vahhso8g-abcd-abcd-91xt-dyc3uv89du');

            List<PKB_Article_Feedback_Deflection__c> afdAfterInsert = [
                    SELECT Id
                    FROM PKB_Article_Feedback_Deflection__c
                    WHERE Session_ID__c = :'vahhso8g-abcd-abcd-91xt-dyc3uv89du'
            ];

            System.assertEquals(1, afdAfterInsert.size(), 'article feedback deflection did not save');
        }

        Test.stopTest();

    }

    @isTest
    static void testAddNegativeFeedbackForArticle() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

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
        System.runAs(testUser) {
            brArticleFeedbackCtrl.addNegativeFeedbackForArticle(articleFields, 'Test comment', '', 'vahhso8g-test-test-91xt-dyc3uv89du');
            List<PKB_Article_Feedback_Deflection__c> afdAfterInsert = [
                    SELECT Id
                    FROM PKB_Article_Feedback_Deflection__c
                    WHERE Session_ID__c = :'vahhso8g-test-test-91xt-dyc3uv89du'
            ];

            System.assertEquals(1, afdAfterInsert.size(), 'article feedback deflection did not save');
        }

        Test.stopTest();

    }
}