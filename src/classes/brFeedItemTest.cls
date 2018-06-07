@isTest
public with sharing class brFeedItemTest {

    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void brFeedItemTest() {

        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {
            FeedItem fi = new FeedItem();
            fi.Title = 'Test';
            fi.Body = 'Test';
            fi.ParentId = UserInfo.getUserId();
            fi.Type = 'QuestionPost';
            fi.Visibility = 'AllUsers';
            insert fi;

            Test.startTest();

            brFeedItemServiceSelector.getQuestionBestComment(0);
            brFeedItemServiceSelector.getQuestion(0);


            brFeedItemService.getFeedItemCount();
            brFeedItemService.getQuestions();
        }

        Test.stopTest();

    }

}