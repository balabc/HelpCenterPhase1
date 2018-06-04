@isTest
public with sharing class brFeedItemTest {

    @isTest
    static void brFeedItemTest() {

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

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