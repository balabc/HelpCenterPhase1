@IsTest
private class brUserMenuCtrlTest {

    @isTest
    static void testCommonMethod() {
        Test.startTest();

        brUserService.getUserInfo();
        brUserService.getUserCount(null);
        brUserService.getUserLeaderboard(null);
        brUserService.brUserReputationWrap dsa = new brUserService.brUserReputationWrap();
        dsa.label = '';
        dsa.minScore = 0;
        dsa.maxScore = 0;

        brUserServiceSelector.getUserMembers(null, 0);
        brUserServiceSelector.getLogUserMember(null);
        brUserServiceSelector.getUserMemberPhotoUrl(null);
        brUserServiceSelector.getUserReputationLevels(null);

        Test.stopTest();
    }

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

    @isTest
    static void getUserType() {
        Test.startTest();
        String userType = brUserMenuCtrl.getUserType();
        Test.stopTest();
        System.assertEquals('Standard', userType, 'wrong user type');
    }

}