@IsTest
private class brMainNavMenuCtrlTest {

    @IsTest
    static void testGetURLByMenuLabel_Negative() {
        String inputLabel = 'testLabel';
        String fullurl = 'https://something.dot/test-page';
        Test.startTest();
            String output = brMainNavMenuCtrl.getURLByMenuLabel(fullurl,inputLabel);
        Test.stopTest();
        System.assertEquals('', output);
    }
    @IsTest
    static void testGetURLByMenuLabel_Positive() {
        String inputLabel = 'testLabel';
        String fullurl = 'https://something.dot/s/communityname/test-page';
        Test.startTest();
            String output = brMainNavMenuCtrl.getURLByMenuLabel(fullurl,inputLabel);
        Test.stopTest();
        System.assertEquals('https://something.dot/s/test-target', output);
    }

    @IsTest
    static void testDetectTargetByMenuLabel() {
        String inputLabel = 'testLabel';
        Test.startTest();
            String output = brMainNavMenuCtrl.detectTargetByMenuLabel(inputLabel);
        Test.stopTest();
        System.assertEquals('/test-target', output);
    }

    @IsTest
    static void testGetMenuItemId_Negative() {
        String inputLabel = '';
        Test.startTest();
            String output = brMainNavMenuCtrl.getMenuItemId(inputLabel);
        Test.stopTest();
        System.assertEquals('', output);
    }
    @IsTest
    static void testGetMenuItemId_Positive() {
        String inputLabel = 'SomethingLikeLabel';
        Test.startTest();
            String output = brMainNavMenuCtrl.getMenuItemId(inputLabel);
        Test.stopTest();
        System.assertEquals('TestIdValue', output);
    }

    @IsTest
    static void testGetTargetByMenuId_Negative() {
        String inputMenuId = '';
        Test.startTest();
            String output = brMainNavMenuCtrl.getTargetByMenuId(inputMenuId);
        Test.stopTest();
        System.assertEquals('', output);
    }
    @IsTest
    static void testGetTargetByMenuId_Positive() {
        String inputMenuId = 'SomethingLikeMenuId';
        Test.startTest();
            String output = brMainNavMenuCtrl.getTargetByMenuId(inputMenuId);
        Test.stopTest();
        System.assertEquals('/test-target', output);
    }

    @IsTest
    static void testGetMenuItems() {
        Test.startTest();

        List<NavigationMenuItem> items = brMainNavMenuCtrl.getMenuItems();

        Test.stopTest();

        System.assertEquals('Test', items[0].Label, 'wrong label');
    }
}