@isTest
public with sharing class brFeedItemTest {

    static testMethod void brFeedItemTest() {

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

        Test.stopTest();

    }

}