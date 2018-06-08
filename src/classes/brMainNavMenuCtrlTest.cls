@IsTest
private class brMainNavMenuCtrlTest {

    @TestSetup
    static void setup() {
        Test.startTest();

        User testUser = brTestDataFactory.createTestStandardProfileUser();

        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');

        Test.stopTest();
    }

    @IsTest
    static void testGetURLByMenuLabel_Negative() {
        String inputLabel = 'testLabel';
        String fullurl = 'https://something.dot/test-page';
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String output = brMainNavMenuCtrl.getURLByMenuLabel(fullurl, inputLabel);
            System.assertEquals('', output);
        }
        Test.stopTest();
    }
    @IsTest
    static void testGetURLByMenuLabel_Positive() {
        String inputLabel = 'testLabel';
        String fullurl = 'https://something.dot/s/communityname/test-page';
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String output = brMainNavMenuCtrl.getURLByMenuLabel(fullurl, inputLabel);
            System.assertEquals('https://something.dot/s/test-target', output);
        }
        Test.stopTest();
    }

    @IsTest
    static void testDetectTargetByMenuLabel() {
        String inputLabel = 'testLabel';
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String output = brMainNavMenuCtrl.detectTargetByMenuLabel(inputLabel);
            System.assertEquals('/test-target', output);
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetMenuItemId_Negative() {
        String inputLabel = '';
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String output = brMainNavMenuCtrl.getMenuItemId(inputLabel);
            System.assertEquals('', output);
        }

        Test.stopTest();
    }
    @IsTest
    static void testGetMenuItemId_Positive() {
        String inputLabel = 'SomethingLikeLabel';
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String output = brMainNavMenuCtrl.getMenuItemId(inputLabel);
            System.assertEquals('TestIdValue', output);
        }

        Test.stopTest();
    }

    @IsTest
    static void testGetTargetByMenuId_Negative() {
        String inputMenuId = '';
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String output = brMainNavMenuCtrl.getTargetByMenuId(inputMenuId);
            System.assertEquals('', output);
        }

        Test.stopTest();
    }
    @IsTest
    static void testGetTargetByMenuId_Positive() {
        String inputMenuId = 'SomethingLikeMenuId';
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String output = brMainNavMenuCtrl.getTargetByMenuId(inputMenuId);
            System.assertEquals('/test-target', output);
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetMenuItems() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {

            List<NavigationMenuItem> items = brMainNavMenuCtrl.getMenuItems();

            System.assertEquals('Test', items[0].Label, 'wrong label');
        }

        Test.stopTest();
    }
}