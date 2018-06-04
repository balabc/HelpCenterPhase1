@IsTest
private class brUserMenuCtrlTest {

    @TestSetup
    static void setup() {
        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

        Test.stopTest();
    }

    @isTest
    static void testCommonMethod() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {

            brUserService.getUserInfo();
            brUserService.getUserCount();
            brUserService.getUserLeaderboard(null);
            brUserService.brUserReputationWrap dsa = new brUserService.brUserReputationWrap();
            dsa.label = '';
            dsa.minScore = 0;
            dsa.maxScore = 0;

            brUserServiceSelector.getUserMembers(null, 0);
            brUserServiceSelector.getLogUserMember(null);
            brUserServiceSelector.getUserMemberPhotoUrl(null);
            brUserServiceSelector.getUserReputationLevels(null);
        }

        Test.stopTest();
    }

    @isTest
    static void testGetCurrentUser() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            User user = brUserMenuCtrl.getCurrentUser();
            System.assertNotEquals(null, user, 'result without current user');
        }
        Test.stopTest();
    }

    @isTest
    static void testGetUserMenuItems() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String menuItems = brUserMenuCtrl.getUserMenuItems();
            System.assertEquals('{"title": "Profile", "url": "profile", "new_window": true}', menuItems, 'wrong menu items');
        }

        Test.stopTest();
    }

    @isTest
    static void testGetUserReputationPoints() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            Decimal reputationPoints = brUserMenuCtrl.getUserReputationPoints();
            System.assertEquals(5, reputationPoints, 'wrong number of reputation points');
        }

        Test.stopTest();
    }

    @isTest
    static void testGetUserReputationLevel() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String reputationLevel = brUserMenuCtrl.getUserReputationLevel();
            System.assertEquals('Level One', reputationLevel, 'wrong reputation level');
        }

        Test.stopTest();
    }

    @isTest
    static void getUserType() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String userType = brUserMenuCtrl.getUserType();
            System.assertEquals('Standard', userType, 'wrong user type');
        }

        Test.stopTest();
    }

}