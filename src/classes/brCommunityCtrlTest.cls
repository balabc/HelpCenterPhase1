@isTest
private class brCommunityCtrlTest {

    @isTest
    private static void testGetUserDisplayName(){
        Test.startTest();

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

        User testUser = new User(Alias = 'testusr', Email='testusr@testorg.com', FirstName='Test',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', CommunityNickname = 'testnickname',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='testusr@testorg.com');

        insert testUser;

        System.runAs(testUser) {

            String uName = brCommunityCtrl.getUserDisplayName(testUser.Id);

            brCommunityCtrl.showUserNickname = true;

            String uName2 = brCommunityCtrl.getUserDisplayName(testUser.Id);

            System.assertEquals('Test Testing', uName);
            System.assertEquals('testnickname', uName2);
        }

        Test.stopTest();
    }
}