@isTest
private class brIdeaTriggerHandlerTest {

    @testSetup
    static void setup() {
        Test.startTest();

        brLghtIdeasSettings__c  communitySettings = new brLghtIdeasSettings__c (Name = 'community', Value__c = 'TestPublic');
        insert communitySettings;

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

        User testUser = new User(Alias = 'testusr', Email='testusr@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='testusr@testorg.com');
        insert testUser;

        //TODO: set brLghtIdeasHelper methods with global access
        //String cId = bedrock.brLghtIdeasHelper.getCommunityId('');
        Community community = [SELECT Id FROM Community WHERE Name = 'TestPublic' LIMIT 1];
        String cId = community.Id;

        List<Idea> ideasList = new List<Idea>();
        ideasList.add(new Idea(Title='Test idea_1', Body='Body of test idea_1', Status='New', Categories='test_1', CommunityId=cId));
        ideasList.add(new Idea(Title='Test idea_2', Body='Body of test idea_2', Status='Delivered', Categories='test_2', CommunityId=cId));

        insert ideasList;

        Test.stopTest();

        Integer recCount = [SELECT COUNT() FROM brLghtIdeasSettings__c  WHERE Name = 'community'];

        System.assertEquals(1, recCount);
    }

    @isTest
    static void testCreateSubscriptionsOnInsert(){
        Idea testIdea;
        User testUser;

        Test.startTest();

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

        testUser = new User(Alias = 'testusr', Email='testusr@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='testusr@testorg.com');

        String cId = brLghtIdeasHelper.getCommunityId('');

        System.runAs(testUser) {
            testIdea = new Idea(Title = 'Test idea', Body = 'Body of test idea', Status = 'New',
                    Categories = 'test', CommunityId = cId);

            insert testIdea;
        }

        Test.stopTest();

        Integer subscrNumber = [SELECT COUNT() FROM brIdeaSubscription__c];
        brIdeaSubscription__c subscr = [SELECT Idea__c, User__c FROM brIdeaSubscription__c LIMIT 1];

        System.assertEquals(1, subscrNumber, 'Invalid number of subscriptions created');
        System.assertEquals(testIdea.Id, subscr.Idea__c, 'Invalid Idea in Subscribtion');
        System.assertEquals(testUser.Id, subscr.User__c, 'Invalid User in subscription');
    }

    @isTest
    static void testSendStatusChangeNotificationsToSubscribers(){
        Test.startTest();
        User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
        Idea testIdea1 = [SELECT Id, Status FROM Idea WHERE Title='Test idea_1' LIMIT 1];
        Idea testIdea2 = [SELECT Id, Status FROM Idea WHERE Title='Test idea_2' LIMIT 1];

        brIdeaSubscription__c subscr = new brIdeaSubscription__c(
                User__c = testUser.Id,
                Idea__c = testIdea1.Id
        );

        insert subscr;

        testIdea1.Status = 'Delivered';

        update testIdea1;

        Test.stopTest();

        System.assert(true);
    }

    @isTest
    static void testSendStatusChangeNotificationsToAssignedUsers(){
        Test.startTest();
        User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com' LIMIT 1];
        Idea testIdea1 = [SELECT Id, Status FROM Idea WHERE Title='Test idea_1' LIMIT 1];

        testIdea1.Status = 'Delivered';

        update testIdea1;

        brIdeasCategoriesAssignment__c assign = new brIdeasCategoriesAssignment__c(
                User__c = testUser.Id,
                Categories__c = 'test_1'
        );

        insert assign;

        testIdea1.Status = 'New';

        update testIdea1;

        Test.stopTest();

        System.assert(true);
    }

}