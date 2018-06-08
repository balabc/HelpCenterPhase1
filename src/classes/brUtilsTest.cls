@isTest
private class brUtilsTest {

    @isTest
    private static void testGenerateToken(){
        Test.startTest();

        String test5 = brUtils.generateToken(5);
        String test10 = brUtils.generateToken(10);
        String test255 = brUtils.generateToken(255);

        System.assertEquals(5, test5.length());
        System.assertEquals(10, test10.length());
        System.assertEquals(44, test255.length());

        Test.stopTest();
    }
}