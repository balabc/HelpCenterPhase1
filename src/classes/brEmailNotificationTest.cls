@isTest
private class brEmailNotificationTest {

    @testSetup
    static void setup(){

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(testUser) {

            brLghtIdeasSettings__c communitySettings = new brLghtIdeasSettings__c(Name = 'community', Value__c = 'TestPublic');

            insert communitySettings;

            String cId = brLghtIdeasHelper.getCommunityId('');
            system.debug('-33 ' + cId);
            Idea testIdea = new Idea(Title = 'Test idea_1', Body = 'Body of test idea_1', Status = 'New', Categories = 'test_1',
                    CommunityId = cId);
            insert testIdea;

            IdeaComment comment = new IdeaComment(CommentBody = 'First comment', IdeaId = testIdea.Id);

            insert comment;

            testIdea = [SELECT Title FROM Idea WHERE Id = :testIdea.Id];
            comment = [SELECT IdeaId FROM IdeaComment WHERE Id = :comment.Id];

            System.assertEquals('Test idea_1', testIdea.Title);
            System.assertEquals(testIdea.Id, comment.IdeaId);
        }
    }

    @isTest
    private static void testAddIdeaCreatedNotification(){
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {

            Integer elogNumOriginal = [SELECT COUNT() FROM brTestEmail__c];

            Idea testIdea = [SELECT Status, Title, Body, CommunityId, CreatorName FROM Idea LIMIT 1];

            brEmailNotification en = new brEmailNotification();

            en.addIdeaCreatedNotification(UserInfo.getUserEmail(), testIdea, 'NewIdeaNotificationToCategoryAssignee');
            en.sendEmails();

            Integer elogNum = [SELECT COUNT() FROM brTestEmail__c];

            System.assertEquals(elogNumOriginal + 1, elogNum);
        }

        Test.stopTest();
    }

    @isTest
    private static void testAddNewCommentNotification(){
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {

            Integer elogNumOriginal = [SELECT COUNT() FROM brTestEmail__c];

            Idea testIdea = [SELECT Id FROM Idea LIMIT 1];
            IdeaComment comment = [
                    SELECT CommentBody, Idea.CommunityId, Idea.Title
                    FROM IdeaComment
                    WHERE IdeaId = :testIdea.Id
                    LIMIT 1
            ];

            brEmailNotification en = new brEmailNotification();

            en.addNewCommentNotification1(UserInfo.getUserEmail(), comment, 'NewCommentNotificationToSubscriber');
            en.addNewCommentNotification1(UserInfo.getUserEmail(), comment, 'NewCommentNotificationToCategoryAssignee');
            en.sendEmails();

            Integer elogNum = [SELECT COUNT() FROM brTestEmail__c];

            System.assertEquals(elogNumOriginal + 2, elogNum);
        }

        Test.stopTest();
    }

    @isTest
    private static void testAddStatusChangeNotification(){
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {

            Integer elogNumOriginal = [SELECT COUNT() FROM brTestEmail__c];

            Idea testIdea = [SELECT Status, Title, Body, CommunityId FROM Idea LIMIT 1];

            brEmailNotification en = new brEmailNotification();

            en.addStatusChangeNotification1(UserInfo.getUserEmail(), testIdea, 'OldStatus', 'ChangeStatusNotificationToSubscriber');
            en.addStatusChangeNotification1(UserInfo.getUserEmail(), testIdea, 'OldStatus', 'ChangeStatusNotificationToCategoryAssignee');
            en.sendEmails();

            Integer elogNum = [SELECT COUNT() FROM brTestEmail__c];

            System.assertEquals(elogNumOriginal + 2, elogNum);

            Test.stopTest();
        }
    }
}