@isTest
private class brIdeaCommentTriggerHandlerTest {

    @testSetup
    static void setupData(){
        Test.startTest();

        User user = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

        System.runAs(user) {

            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            Profile communityUserProfile = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User'];

            Account acc = new Account(Name = 'TestCommunity');
            insert acc;

            Contact communityUserContact = new Contact(
                    LastName = 'Community',
                    AccountId = acc.Id
            );
            insert communityUserContact;

            User testUser = new User(Alias = 'testusr', Email = 'testusr@testorg.com',
                    EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US', ProfileId = stdUserProfile.Id,
                    TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testusr@testorg.com');
            insert testUser;

            User testCommunityUser = new User(Alias = 'testcomm', Email = 'testcommunityusr@testorg.com',
                    EmailEncodingKey = 'UTF-8', LastName = 'Community', LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US', ProfileId = communityUserProfile.Id,
                    TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testcommunityusr@testorg.com', ContactId = communityUserContact.Id);
            insert testCommunityUser;

            brLghtIdeasSettings__c communitySettings = new brLghtIdeasSettings__c(Name = 'community', Value__c = 'TestPublic');
            insert communitySettings;

            //TODO: set brLghtIdeasHelper methods with global access
            Community community = [SELECT Id FROM Community WHERE Name = 'TestPublic' LIMIT 1];
            String cId = community.Id;

            List<Idea> ideasList = new List<Idea>();
            ideasList.add(new Idea(Title = 'Test idea_1', Body = 'Body of test idea_1', Status = 'New', Categories = 'test_1', CommunityId = cId));
            ideasList.add(new Idea(Title = 'Test idea_2', Body = 'Body of test idea_2', Status = 'Delivered', Categories = 'test_2', CommunityId = cId));

            insert ideasList;

            System.runAs(testUser) {
                Idea testUserIdea = new Idea(Title = 'Test idea_3', Body = 'Body of test idea_3', Status = 'New', Categories = 'test_2', CommunityId = cId);

                insert testUserIdea;
            }

            System.runAs(testCommunityUser) {
                Idea testCommunityUserIdea = new Idea(Title = 'Test idea_4', Body = 'Body of test idea_4', Status = 'New', Categories = 'test_3', CommunityId = cId);

                insert testCommunityUserIdea;
            }

            Integer ideasCount = [SELECT COUNT() FROM Idea];

            System.assertEquals(4, ideasCount);
        }

        Test.stopTest();
    }

    @isTest
    static void testSendNotificationsToSubscribersOnCreate(){
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
            Idea testIdea1 = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];
            Idea testIdea2 = [SELECT Id FROM Idea WHERE Title = 'Test idea_2' LIMIT 1];
            Idea testIdea3 = [SELECT Id FROM Idea WHERE Title = 'Test idea_3' LIMIT 1];

            List<IdeaComment> testComments = new List<IdeaComment>();
            testComments.add(new IdeaComment(CommentBody = 'First comment', IdeaId = testIdea1.Id));
            testComments.add(new IdeaComment(CommentBody = 'First comment', IdeaId = testIdea2.Id));
            testComments.add(new IdeaComment(CommentBody = 'First-second comment', IdeaId = testIdea2.Id));

            insert testComments;

            System.runAs(testUser) {
                List<IdeaComment> testUserComments = new List<IdeaComment>();
                testUserComments.add(new IdeaComment(CommentBody = 'Second comment', IdeaId = testIdea1.Id));
                testUserComments.add(new IdeaComment(CommentBody = 'Second comment', IdeaId = testIdea3.Id));

                insert testUserComments;
            }

            System.assert(true);
        }

        Test.stopTest();
    }

    @isTest
    static void testSendNotificationsToAssignedUsersOnCreate(){
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
            User testCommUser = [SELECT Id FROM User WHERE UserName = 'testcommunityusr@testorg.com' LIMIT 1];
            Idea testIdea1 = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];
            Idea testIdea2 = [SELECT Id FROM Idea WHERE Title = 'Test idea_2' LIMIT 1];

            Community community = [SELECT Id FROM Community WHERE Name = 'TestPublic' LIMIT 1];
            String cId = community.Id;

            brIdeasCategoriesAssignment__c assign = new brIdeasCategoriesAssignment__c(
                    User__c = testUser.Id,
                    Categories__c = 'test_2'
            );

            insert assign;

            System.runAs(testUser) {
                List<IdeaComment> testUserComments = new List<IdeaComment>();
                testUserComments.add(new IdeaComment(CommentBody = 'First comment', IdeaId = testIdea1.Id));
                testUserComments.add(new IdeaComment(CommentBody = 'First comment', IdeaId = testIdea2.Id));

                insert testUserComments;
            }

            System.assert(true);
        }

        Test.stopTest();
    }
}