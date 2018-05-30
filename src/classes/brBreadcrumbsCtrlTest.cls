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

        System.assertNotEquals(null, crumbsData);
        System.assertNotEquals(crumbsDataBlank, crumbsData);
    }

    static testMethod void testListViewObj() {
        String fullurl = 'https://something.dot/s/CollaborationGroup/whatever';
        String recordId = '';//empty not detected

        List<ListView> listViews = [SELECT Id, SobjectType FROM ListView WHERE SobjectType = 'CollaborationGroup'];
        if (listViews.size() > 0) {
            recordId = listViews.get(0).Id;
        }

        brBreadcrumbsCtrl.BreadCrumbsData crumbsData = new brBreadcrumbsCtrl.BreadCrumbsData();
        brBreadcrumbsCtrl.BreadCrumbsData crumbsDataBlank = new brBreadcrumbsCtrl.BreadCrumbsData();

        Test.startTest();
            crumbsData = brBreadcrumbsCtrl.getBreadCrumbsData(fullurl, recordId);
        Test.stopTest();

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

    static testMethod void testDataGroup() {
        CollaborationGroup groupObj = new CollaborationGroup(Name='testGroup', CollaborationType='Public');
        insert(groupObj);

        String fullurl = 'https://something.dot/s/group/' + groupObj.Id;
        String recordId = '';//empty not detected

        Test.startTest();
        brBreadcrumbsCtrl.BreadCrumbsData crumbsData = brBreadcrumbsCtrl.getBreadCrumbsData(fullurl, recordId);
        Test.stopTest();

        System.assertNotEquals(null, crumbsData);
    }

    static testMethod void testDataByURL() {

        Test.startTest();
        brBreadcrumbsCtrl.BreadCrumbsData crumbsDataTopic = brBreadcrumbsCtrl.getBreadCrumbsData('https://something.dot/s/topic/whatever', '');
        brBreadcrumbsCtrl.BreadCrumbsData crumbsDataQuestion = brBreadcrumbsCtrl.getBreadCrumbsData('https://something.dot/s/question/whatever', '');
        brBreadcrumbsCtrl.BreadCrumbsData crumbsDataCollaborationGroup = brBreadcrumbsCtrl.getBreadCrumbsData('https://something.dot/s/CollaborationGroup/whatever', '');
        brBreadcrumbsCtrl.BreadCrumbsData crumbsDataOther = brBreadcrumbsCtrl.getBreadCrumbsData('https://something.dot/s/somthing-other/whatever', '');
        brBreadcrumbsCtrl.BreadCrumbsData crumbsDataOther2 = brBreadcrumbsCtrl.getBreadCrumbsData('https://something.dot/s/somthing-other/s/whatever', '');
        Test.stopTest();

        System.assertNotEquals(null, crumbsDataTopic);
        System.assertNotEquals(null, crumbsDataQuestion);
        System.assertNotEquals(null, crumbsDataCollaborationGroup);
        System.assertNotEquals(null, crumbsDataOther);
        System.assertNotEquals(null, crumbsDataOther2);
    }

    static testMethod void testGetMenuItemByID() {
        String menuID = '';
        List<NavigationMenuItem> menuItems = [SELECT Id FROM NavigationMenuItem LIMIT 1];
        if (menuItems.size() > 0) {
            menuID = String.valueOf(menuItems.get(0).Id);
        }
        Test.startTest();
        NavigationMenuItem itemResult = brBreadcrumbsCtrl.getMenuItemByID(menuID);
        Test.stopTest();

        System.assertNotEquals(null, itemResult);
    }


}