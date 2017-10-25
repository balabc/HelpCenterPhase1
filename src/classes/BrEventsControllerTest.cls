@IsTest
private class BrEventsControllerTest {

    @isTest
    public static void testGetUserInfo() {
        Map<String, String> uInf = BrEventsController.getUserInfo();

        System.assertEquals(true, String.isNotEmpty(uInf.get('Id')), 'Id property is empty');
        System.assertEquals(true, String.isNotEmpty(uInf.get('Name')), 'Name property is empty');
        System.assertEquals(true, String.isNotEmpty(uInf.get('Username')), 'Username property is empty');
        System.assertEquals(true, String.isNotEmpty(uInf.get('Email')), 'Email property is empty');
        System.assertEquals(true, String.isNotEmpty(uInf.get('Type')), 'Type property is empty');
    }
}