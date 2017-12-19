@IsTest
private class brLandingTilesCtrlTest {
    @IsTest
    static void testGetListViews() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='Active Groups');
        newGroup.CollaborationType = 'public';
        insert newGroup;

        Test.startTest();

        ListView view = brLandingTilesCtrl.getListViews();

        Test.stopTest();

        System.assertEquals(String.valueOf(newGroup.getSObjectType()), view.SObjectType, 'wrong object type');

        System.assertNotEquals(null, view.Id, 'wrong id');
    }
}