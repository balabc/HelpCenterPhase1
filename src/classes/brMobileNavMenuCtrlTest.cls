@isTest
private class brMobileNavMenuCtrlTest {
    static testMethod void brMobileNavMenuCtrlTest() {
    	
    	brPhoneSupportList__c phone = new brPhoneSupportList__c();
    	phone.Country__c = 'US';
    	phone.Phone__c = '1111111';
    	phone.Name = 'US';
    	insert phone;
    	
    	Test.startTest();
    		System.assertEquals(1,brMobileNavMenuCtrl.getPhoneList().size());
    		System.assertEquals(UserInfo.getUserId(),Id.valueOF(brMobileNavMenuCtrl.getUserInfo().id));
    	Test.stopTest();
    }
}