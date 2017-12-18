@IsTest
private class brCommunityLandingTileCtrlTest {
    @IsTest
    static void testGetListViews() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='Active Groups');
        newGroup.CollaborationType = 'public';
        insert newGroup;

        Test.startTest();

        ListView view = brCommunityLandingTileCtrl.getListViews();

        Test.stopTest();

        System.assertEquals(String.valueOf(newGroup.getSObjectType()), view.SObjectType, 'wrong object type');

        System.assertNotEquals(null, view.Id, 'wrong id');
    }
}