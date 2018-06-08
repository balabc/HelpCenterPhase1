@IsTest
private class brLandingTilesCtrlTest {
    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @IsTest
    static void testGetListViews() {
        Test.startTest();

        User user = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        System.assertEquals('sysuserbaker@test.com', user.UserName, 'wrong username');

        System.runAs(user) {
            CollaborationGroup newGroup = new CollaborationGroup(Name = 'Active Groups');
            newGroup.CollaborationType = 'public';
            insert newGroup;

            ListView view = brLandingTilesCtrl.getListViews();

            System.assertEquals(String.valueOf(newGroup.getSObjectType()), view.SObjectType, 'wrong object type');

            System.assertNotEquals(null, view.Id, 'wrong id');
        }

        Test.stopTest();
    }
}