
@isTest
private class brLiveAgentChatButtonTest {

    @isTest
    static void test_getContactIdCurrentUser() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');
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