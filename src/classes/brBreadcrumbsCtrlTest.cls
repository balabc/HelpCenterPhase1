@IsTest
private class brBreadcrumbsCtrlTest {

    static testMethod void testMainFunction() {
        String fullurl = 'https://something.dot/s/communityname';
        String recordId = '';//empty not detected
        Test.startTest();
            List<Map<String,String>> output = brBreadcrumbsCtrl.doStaff(fullurl, recordId);
        Test.stopTest();

        System.debug(output);
        System.assertNotEquals(null, output);
    }

    static testMethod void testMainFunction_parceURL() {

        BR_Event__c eventObj = new BR_Event__c(Name='EventOne');
        eventObj.Start_Date__c = date.newInstance(2017, 10, 10);

        insert eventObj;

        String fullurl = 'https://something.dot/s/communityname/events#' + eventObj.id;
        String recordId = '';//empty not detected
        Test.startTest();
            List<Map<String,String>> output = brBreadcrumbsCtrl.doStaff(fullurl, recordId);
        Test.stopTest();

        System.debug(output);
        System.assertNotEquals(null, output);
    }

    static testMethod void testNavigationMenu() {
        //NavigationMenuItem menuItem = new NavigationMenuItem();
        //menuItem.Target = '/what';
        //menuItem.Label = 'What';
        //insert menuItem;
        //Test.startTest();
        //Test.stopTest();
        //System.assertNotEquals(null, kArticles);
        //System.assertEquals(0, kArticles.size());//TODO:need to gen article to count them

    }

}