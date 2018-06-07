@isTest
private class brLghtIdeasHelperTest {

    @testSetup
    static void setup() {
        Test.startTest();

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        Profile communityUserProfile = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User'];

        brLghtIdeasSettings__c communitySettings = new brLghtIdeasSettings__c(Name = 'community', Value__c = 'TestPublic');
        insert communitySettings;

        Account acc = new Account(Name='TestCommunity');
        insert acc;

        Contact communityUserContact = new Contact(
                LastName = 'Community',
                AccountId = acc.Id
        );
        insert communityUserContact;

        User testUser = new User(Alias = 'testusr', Email='testusr@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='testusr@testorg.com');
        insert testUser;

        User testCommunityUser = new User(Alias = 'testcomm', Email='testcommunityusr@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Community', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = communityUserProfile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='testcommunityusr@testorg.com', ContactId=communityUserContact.Id);
        insert testCommunityUser;

        String cId = brLghtIdeasHelper.getCommunityId('');

        Idea idea1 = new Idea(Title='Test idea_1', Body='Body of test idea_1', Status='New', Categories='test_1', CommunityId=cId);

        insert idea1;

        System.runAs(testUser){
            Idea idea2 = new Idea(Title='Test idea_2', Body='Body of test idea_2', Status='New', Categories='test_2', CommunityId=cId);

            insert idea2;
        }

        Test.stopTest();

        Integer ideasCount = [SELECT COUNT() FROM Idea];

        System.assertEquals(2, ideasCount);
    }

    @isTest
    private static void testAddSubscriberToIdea(){
        Test.startTest();

        User testUser = [SELECT Id FROM User WHERE Username = 'testusr@testorg.com' LIMIT 1];
        User testCommunityUser = [SELECT Id FROM User WHERE Username = 'testcommunityusr@testorg.com' LIMIT 1];
        Idea idea1 = [SELECT Id FROM Idea WHERE Title='Test idea_1' LIMIT 1];
        Idea idea2 = [SELECT Id FROM Idea WHERE Title='Test idea_2' LIMIT 1];
        Integer initialCount = [SELECT COUNT() FROM brIdeaSubscription__c];

        brLghtIdeasHelper.addSubscriberToIdea(testUser.Id, idea1.Id);
        brLghtIdeasHelper.addSubscriberToIdea(testCommunityUser.Id, idea2.Id);

        Test.stopTest();

        Integer resultCount = [SELECT COUNT() FROM brIdeaSubscription__c];

        System.assertEquals(initialCount + 2, resultCount);
    }

    @isTest
    private static void testUnsubscribeUserFromIdea(){
        Test.startTest();

        User testUser = [SELECT Id FROM User WHERE Username = 'testusr@testorg.com' LIMIT 1];
        Idea idea1 = [SELECT Id FROM Idea WHERE Title='Test idea_1' LIMIT 1];
        Integer subscrCountInitial = [SELECT COUNT() FROM brIdeaSubscription__c];

        brIdeaSubscription__c subscr = new brIdeaSubscription__c(
                Idea__c = idea1.Id,
                User__c = testUser.Id
        );

        insert subscr;

        Integer subscrCountAfterInsert = [SELECT COUNT() FROM brIdeaSubscription__c];

        brLghtIdeasHelper.unsubscribeUserFromIdea(idea1.Id, testUser.Id);

        Integer subscrCountAfterUnsubscr = [SELECT COUNT() FROM brIdeaSubscription__c];

        Test.stopTest();

        System.assertEquals(subscrCountInitial + 1, subscrCountAfterInsert);
        System.assertEquals(subscrCountInitial, subscrCountAfterUnsubscr);
    }

    @isTest
    private static void testUnsubscribeFromIdeaByToken(){
        Test.startTest();

        User testUser = [SELECT Id FROM User WHERE Username = 'testusr@testorg.com' LIMIT 1];
        Idea idea1 = [SELECT Id FROM Idea WHERE Title='Test idea_1' LIMIT 1];
        Integer subscrCountInitial = [SELECT COUNT() FROM brIdeaSubscription__c];

        brIdeaSubscription__c subscr = new brIdeaSubscription__c(
                Idea__c = idea1.Id,
                User__c = testUser.Id,
                Token__c = 'testToken'
        );

        insert subscr;

        Integer subscrCountAfterInsert = [SELECT COUNT() FROM brIdeaSubscription__c];

        brLghtIdeasHelper.unsubscribeFromIdeaByToken('testToken');

        Integer subscrCountAfterUnsubscr = [SELECT COUNT() FROM brIdeaSubscription__c];

        Test.stopTest();

        System.assertEquals(subscrCountInitial + 1, subscrCountAfterInsert);
        System.assertEquals(subscrCountInitial, subscrCountAfterUnsubscr);
    }
}