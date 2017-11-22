@IsTest
private class brUserMenuCtrlTest {
    @isTest
    static void testGetCurrentUser() {

        Test.startTest();

        User user = brUserMenuCtrl.getCurrentUser();

        Test.stopTest();

        System.assertNotEquals(null, user, 'result without current user');
    }

    @isTest
    static void testGetUserMenuItems() {

        Test.startTest();

        String menuItems = brUserMenuCtrl.getUserMenuItems();

        Test.stopTest();

        System.assertEquals('{"title": "Profile", "url": "profile", "new_window": true}', menuItems, 'wrong menu items');
    }

    @isTest
    static void testGetUserReputationPoints() {

        Test.startTest();

        Decimal reputationPoints = brUserMenuCtrl.getUserReputationPoints();

        Test.stopTest();

        System.assertEquals(5, reputationPoints, 'wrong number of reputation points');
    }

    @isTest
    static void testGetUserReputationLevel() {

        Test.startTest();

        String reputationLevel = brUserMenuCtrl.getUserReputationLevel();

        Test.stopTest();

        System.assertEquals('Level One', reputationLevel, 'wrong reputation level');
    }
}