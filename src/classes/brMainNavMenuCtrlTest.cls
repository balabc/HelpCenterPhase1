@IsTest
private class brMainNavMenuCtrlTest {

    @isTest
    static void testGetURLByMenuLabel_Negative() {
        String inputLabel = 'testLabel';
        String fullurl = 'https://something.dot/test-page';
        Test.startTest();
            String output = brMainNavMenuCtrl.getURLByMenuLabel(fullurl,inputLabel);
        Test.stopTest();
        System.assertEquals('', output);
    }
    @isTest
    static void testGetURLByMenuLabel_Positive() {
        String inputLabel = 'testLabel';
        String fullurl = 'https://something.dot/s/communityname/test-page';
        Test.startTest();
            String output = brMainNavMenuCtrl.getURLByMenuLabel(fullurl,inputLabel);
        Test.stopTest();
        System.assertEquals('https://something.dot/s/test-target', output);
    }

    @isTest
    static void testDetectTargetByMenuLabel() {
        String inputLabel = 'testLabel';
        Test.startTest();
            String output = brMainNavMenuCtrl.detectTargetByMenuLabel(inputLabel);
        Test.stopTest();
        System.assertEquals('/test-target', output);
    }

    @isTest
    static void testGetMenuItemId_Negative() {
        String inputLabel = '';
        Test.startTest();
            String output = brMainNavMenuCtrl.getMenuItemId(inputLabel);
        Test.stopTest();
        System.assertEquals('', output);
    }
    @isTest
    static void testGetMenuItemId_Positive() {
        String inputLabel = 'SomethingLikeLabel';
        Test.startTest();
            String output = brMainNavMenuCtrl.getMenuItemId(inputLabel);
        Test.stopTest();
        System.assertEquals('TestIdValue', output);
    }

    @isTest
    static void testGetTargetByMenuId_Negative() {
        String inputMenuId = '';
        Test.startTest();
            String output = brMainNavMenuCtrl.getTargetByMenuId(inputMenuId);
        Test.stopTest();
        System.assertEquals('', output);
    }
    @isTest
    static void testGetTargetByMenuId_Positive() {
        String inputMenuId = 'SomethingLikeMenuId';
        Test.startTest();
            String output = brMainNavMenuCtrl.getTargetByMenuId(inputMenuId);
        Test.stopTest();
        System.assertEquals('/test-target', output);
    }

    @isTest
    static void testGetLabels() {
        Test.startTest();

        List<String> labels = brMainNavMenuCtrl.getLabels();

        Test.stopTest();

        System.assertEquals('Test', labels[0], 'wrong labels');

    }
}