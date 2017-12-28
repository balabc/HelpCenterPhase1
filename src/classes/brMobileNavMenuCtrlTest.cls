@isTest
private class brMobileNavMenuCtrlTest {

    static testMethod void brMobileNavMenuCtrlTest() {

        brPhoneSupportList__c phone = new brPhoneSupportList__c();
        phone.Country__c = 'US';
        phone.Phone__c = '1111111';
        phone.Name = 'US';
        insert phone;

        Test.startTest();
        System.assertEquals(1, brMobileNavMenuCtrl.getPhoneList().size());
        System.assertEquals(UserInfo.getUserId(), Id.valueOF(brMobileNavMenuCtrl.getUserInfo().id));

        brNavigationMenuItemModel t123 = new brNavigationMenuItemModel();
        t123.id = '';
        t123.label = '';
        t123.parentId = '';
        t123.position = 1;
        t123.dataCategory = '';
        t123.objectName = '';
        t123.target = '';
        t123.type = '';
        t123.hasSubMenu = true;
        t123.subMenu = new List<brNavigationMenuItemModel>();

        brNavigationMenuItemServiceSelector.getArticle('test', 'test');
        brNavigationMenuItemServiceSelector.getNavigationMenuItem('test');
        brNavigationMenuItemService.getArticleByUrl('test');
        brNavigationMenuItemService.getMetaDataMenuByArticleType('test');
        brNavigationMenuItemService.getNavigationMenu();
        brNavigationMenuItemServiceSelector.getCurrentNavigationMenu(null);
        brNavigationMenuItemServiceSelector.getMetaDataMenu();
        brNavigationMenuItemServiceSelector.getMetaDataCategoryMenu();
        brNavigationMenuItemServiceSelector.getMetaDataMenuByArticleType('test');

        brMobileNavMenuCtrl.getNavigationMenu();
        brMobileNavMenuCtrl.getArticle('test');
        brMobileNavMenuCtrl.getMetaDataMenuByArticleType('test');
        Test.stopTest();
    }

}