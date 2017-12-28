@isTest
public with sharing class brFeedItemTest {

    static testMethod void brFeedItemTest() {

        Topic top = new Topic();
        top.Name = 'Test';
        insert top;

        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;

        FeedItem fi = new FeedItem();
        fi.Title = 'Test';
        fi.Body = 'Test';
        fi.ParentId = acc.id;
        insert fi;

        TopicAssignment ta = new TopicAssignment();
        ta.TopicId = top.id;
        ta.EntityId = fi.id;
        insert ta;

        Test.startTest();

        brFeedItemServiceSelector.getTopics();
        brFeedItemServiceSelector.getTopicAssignments(new Set<Id>());
        brFeedItemServiceSelector.getQuestionBestComment(new Set<Id>(), 0);
        brFeedItemServiceSelector.getQuestion(new Set<Id>(), 0);


        brFeedItemService.getFeedItemCount();
        brFeedItemService.getQuestions();

        Test.stopTest();

    }

}