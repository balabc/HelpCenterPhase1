@IsTest
private class brLandingTilesCtrlTest {
    @IsTest
    static void testGetListViews() {
        Test.startTest();

        User user = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', user.UserName, 'wrong username');

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