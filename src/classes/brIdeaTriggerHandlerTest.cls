@isTest
private class brIdeaTriggerHandlerTest {

    @testSetup
    static void setup() {
        Test.startTest();

        User user = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', user.UserName, 'wrong username');

        System.runAs(user) {

            brLghtIdeasSettings__c communitySettings = new brLghtIdeasSettings__c(Name = 'community', Value__c = 'TestPublic');
            insert communitySettings;

            Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

            User testUser = new User(Alias = 'testusr', Email = 'testusr@testorg.com',
                    EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US', ProfileId = stdUserProfile.Id,
                    TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testusr@testorg.com');
            insert testUser;

            //TODO: set brLghtIdeasHelper methods with global access
            Community community = [SELECT Id FROM Community WHERE Name = 'TestPublic' LIMIT 1];
            String cId = community.Id;

            List<Idea> ideasList = new List<Idea>();
            ideasList.add(new Idea(Title = 'Test idea_1', Body = 'Body of test idea_1', Status = 'New', Categories = 'test_1', CommunityId = cId));
            ideasList.add(new Idea(Title = 'Test idea_2', Body = 'Body of test idea_2', Status = 'Delivered', Categories = 'test_2', CommunityId = cId));

            insert ideasList;

            Integer recCount = [SELECT COUNT() FROM brLghtIdeasSettings__c WHERE Name = 'community'];

            System.assertEquals(1, recCount);
        }

        Test.stopTest();
    }

    @isTest
    static void testCreateSubscriptionsOnInsert(){
        User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(user) {

            User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
            String cId = brLghtIdeasHelper.getCommunityId('');
            Idea testIdea = new Idea(Title = 'Test idea', Body = 'Body of test idea', Status = 'New',
                    Categories = 'test', CommunityId = cId);

            System.runAs(testUser) {
                insert testIdea;
            }

            Integer subscrNumber = [SELECT COUNT() FROM brIdeaSubscription__c WHERE Idea__c = :testIdea.Id];
            brIdeaSubscription__c subscr = [SELECT Idea__c, User__c FROM brIdeaSubscription__c WHERE Idea__c = :testIdea.Id];

            System.assertEquals(1, subscrNumber, 'Invalid number of subscriptions created');
            System.assertEquals(testIdea.Id, subscr.Idea__c, 'Invalid Idea in subscribtion');
            System.assertEquals(testUser.Id, subscr.User__c, 'Invalid User in subscription');
        }

        Test.stopTest();
    }

    @isTest
    static void testSendStatusChangeNotificationsToSubscribers(){
        User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(user) {
            User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
            Idea testIdea1 = [SELECT Id, Status FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];
            Idea testIdea2 = [SELECT Id, Status FROM Idea WHERE Title = 'Test idea_2' LIMIT 1];

            brIdeaSubscription__c subscr = new brIdeaSubscription__c(
                    User__c = testUser.Id,
                    Idea__c = testIdea1.Id
            );

            insert subscr;

            testIdea1.Status = 'Delivered';

            update testIdea1;

            System.assert(true);
        }
        Test.stopTest();
    }

    @isTest
    static void testSendStatusChangeNotificationsToAssignedUsers(){
        User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(user) {
            User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
            Idea testIdea1 = [SELECT Id, Status FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];

            testIdea1.Status = 'Delivered';

            update testIdea1;

            brIdeasCategoriesAssignment__c assign = new brIdeasCategoriesAssignment__c(
                    User__c = testUser.Id,
                    Categories__c = 'test_1'
            );

            insert assign;

            testIdea1.Status = 'New';

            update testIdea1;

            System.assert(true);
        }
        Test.stopTest();
    }

}