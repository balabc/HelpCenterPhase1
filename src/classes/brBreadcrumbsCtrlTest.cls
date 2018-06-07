@IsTest
private class brBreadcrumbsCtrlTest {

    @TestSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void testMainFunction() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String fullurl = 'https://something.dot/s/communityname';
            String recordId = '';//empty not detected

            brBreadcrumbsCtrl.BreadCrumbsData crumbsData = new brBreadcrumbsCtrl.BreadCrumbsData();
            brBreadcrumbsCtrl.BreadCrumbsData crumbsDataBlank = new brBreadcrumbsCtrl.BreadCrumbsData();
            crumbsData = brBreadcrumbsCtrl.getBreadCrumbsData(fullurl, recordId);
            System.assertNotEquals(null, crumbsData);
            System.assertNotEquals(crumbsDataBlank, crumbsData);
        }

        Test.stopTest();

    }

    @isTest
    static void testListViewObj() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String fullurl = 'https://something.dot/s/CollaborationGroup/whatever';
            String recordId = '';//empty not detected

            List<ListView> listViews = [SELECT Id, SobjectType FROM ListView WHERE SobjectType = 'CollaborationGroup'];
            if (listViews.size() > 0) {
                recordId = listViews.get(0).Id;
            }

            brBreadcrumbsCtrl.BreadCrumbsData crumbsData = new brBreadcrumbsCtrl.BreadCrumbsData();
            brBreadcrumbsCtrl.BreadCrumbsData crumbsDataBlank = new brBreadcrumbsCtrl.BreadCrumbsData();
            crumbsData = brBreadcrumbsCtrl.getBreadCrumbsData(fullurl, recordId);
            System.assertNotEquals(null, crumbsData);
            System.assertNotEquals(crumbsDataBlank, crumbsData);
        }

        Test.stopTest();
    }
/*

    @isTest
    static void testMainFunction_parceURL() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            BR_Event__c eventObj = new BR_Event__c(Name='EventOne');
            eventObj.Start_Date__c = date.newInstance(2017, 10, 10);
            insert eventObj;

            brBreadcrumbsCtrl.BreadCrumbsData crumbsData = new brBreadcrumbsCtrl.BreadCrumbsData();

            String fullurl = 'https://something.dot/s/communityname/events#' + eventObj.id;
            String recordId = '';//empty not detected
            crumbsData = brBreadcrumbsCtrl.getBreadCrumbsData(fullurl, recordId);
            System.assertNotEquals(null, crumbsData);
        }

        Test.stopTest();
    }
*/

    @isTest
    static void testDataGroup() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            CollaborationGroup groupObj = new CollaborationGroup(Name='testGroup', CollaborationType='Public');
            insert(groupObj);

            String fullurl = 'https://something.dot/s/group/' + groupObj.Id;
            String recordId = '';//empty not detected
            brBreadcrumbsCtrl.BreadCrumbsData crumbsData = brBreadcrumbsCtrl.getBreadCrumbsData(fullurl, recordId);
            System.assertNotEquals(null, crumbsData);
        }

        Test.stopTest();

    }

    @isTest
    static void testDataByURL() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            brBreadcrumbsCtrl.BreadCrumbsData crumbsDataTopic = brBreadcrumbsCtrl.getBreadCrumbsData('https://something.dot/s/topic/whatever', '');
            brBreadcrumbsCtrl.BreadCrumbsData crumbsDataQuestion = brBreadcrumbsCtrl.getBreadCrumbsData('https://something.dot/s/question/whatever', '');
            brBreadcrumbsCtrl.BreadCrumbsData crumbsDataCollaborationGroup = brBreadcrumbsCtrl.getBreadCrumbsData('https://something.dot/s/CollaborationGroup/whatever', '');
            brBreadcrumbsCtrl.BreadCrumbsData crumbsDataOther = brBreadcrumbsCtrl.getBreadCrumbsData('https://something.dot/s/somthing-other/whatever', '');
            brBreadcrumbsCtrl.BreadCrumbsData crumbsDataOther2 = brBreadcrumbsCtrl.getBreadCrumbsData('https://something.dot/s/somthing-other/s/whatever', '');
            System.assertNotEquals(null, crumbsDataTopic);
            System.assertNotEquals(null, crumbsDataQuestion);
            System.assertNotEquals(null, crumbsDataCollaborationGroup);
            System.assertNotEquals(null, crumbsDataOther);
            System.assertNotEquals(null, crumbsDataOther2);
        }

        Test.stopTest();
    }

    @isTest
    static void testGetMenuItemByID() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String menuID = '';
            List<NavigationMenuItem> menuItems = [SELECT Id FROM NavigationMenuItem LIMIT 1];
            if (menuItems.size() > 0) {
                menuID = String.valueOf(menuItems.get(0).Id);
            }
            NavigationMenuItem itemResult = brBreadcrumbsCtrl.getMenuItemByID(menuID);
            System.assertNotEquals(null, itemResult);
        }

        Test.stopTest();

    }


}