@IsTest
private class brBreadcrumbsCtrlTest {

    static testMethod void testMainFunction() {
        String fullurl = 'https://something.dot/s/communityname';
        String recordId = '';//empty not detected

        brBreadcrumbsCtrl.BreadCrumbsData crumbsData = new brBreadcrumbsCtrl.BreadCrumbsData();
        brBreadcrumbsCtrl.BreadCrumbsData crumbsDataBlank = new brBreadcrumbsCtrl.BreadCrumbsData();

        Test.startTest();
            crumbsData = brBreadcrumbsCtrl.getBreadCrumbsData(fullurl, recordId);
        Test.stopTest();

        //System.debug(output);
        System.assertNotEquals(null, crumbsData);
        System.assertNotEquals(crumbsDataBlank, crumbsData);
    }

    static testMethod void testMainFunction_parceURL() {

        BR_Event__c eventObj = new BR_Event__c(Name='EventOne');
        eventObj.Start_Date__c = date.newInstance(2017, 10, 10);
        insert eventObj;

        brBreadcrumbsCtrl.BreadCrumbsData crumbsData = new brBreadcrumbsCtrl.BreadCrumbsData();

        String fullurl = 'https://something.dot/s/communityname/events#' + eventObj.id;
        String recordId = '';//empty not detected
        Test.startTest();
        crumbsData = brBreadcrumbsCtrl.getBreadCrumbsData(fullurl, recordId);
        Test.stopTest();

        System.assertNotEquals(null, crumbsData);
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