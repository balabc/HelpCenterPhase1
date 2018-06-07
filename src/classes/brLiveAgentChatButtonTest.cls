
@isTest
private class brLiveAgentChatButtonTest {

    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void test_getContactIdCurrentUser() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
        Test.startTest();

        System.runAs(testUser) {
            // Implement test code
            User iam = [SELECT ContactId,Name FROM User where id = :UserInfo.getUserId()];

            Contact myC = brLiveAgentChatButton.getContact(iam.ContactId);
            if (myC != null)
                System.assertEquals(iam.ContactId, myC.Id);
        }
        Test.stopTest();
    }

}