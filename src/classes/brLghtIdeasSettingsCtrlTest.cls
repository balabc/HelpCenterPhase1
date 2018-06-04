@isTest
private class brLghtIdeasSettingsCtrlTest {

	@TestSetup
	public static void testSetup(){
		Test.startTest();

		User testUser = brTestDataFactory.createTestStandardProfileUser();

		System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

		System.runAs(testUser) {
			brLghtIdeasSettings__c setStatusUpdate = new brLghtIdeasSettings__c(Name = 'status_update');
			setStatusUpdate.Value__c = '{"active":false,"threshold":10,"original_status":"New","new_status":"Accepted"}';

			brLghtIdeasSettings__c communitySettings = new brLghtIdeasSettings__c(Name = 'community', Value__c = 'Public');

			brLghtIdeasSettings__c emailIdSettings = new brLghtIdeasSettings__c(Name = 'orgwide_email_id', Value__c = '');

			insert new List<brLghtIdeasSettings__c>{
					setStatusUpdate, communitySettings, emailIdSettings
			};

			Integer settingsCount = [SELECT COUNT() FROM brLghtIdeasSettings__c];

			System.assertEquals(3, settingsCount);
		}
		Test.stopTest();
	}

	@isTest
	public static void testAll() {
		User testUser = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(testUser) {
			brLghtIdeasSettingsCtrl ctrlObj1 = new brLghtIdeasSettingsCtrl();
			System.assertEquals(true, ctrlObj1.zonesOptions.size() > 0, 'Invalid zone options number');

			PageReference pageRefRes1 = ctrlObj1.saveSettings();
			System.assertEquals('System.PageReference[null]', String.valueOf(pageRefRes1), 'Method should return null');

			brLghtIdeasSettingsCtrl ctrlObj2 = new brLghtIdeasSettingsCtrl();

			ctrlObj2.selectedZone = 'Public';
			ctrlObj2.isStatusUpdateEnabled = true;
			ctrlObj2.limitForStatus = '5';

			PageReference pageRefRes2 = ctrlObj2.saveSettings();

			brLghtIdeasSettings__c updateStatusSettings = [SELECT Value__c FROM brLghtIdeasSettings__c WHERE Name = 'status_update' LIMIT 1];
			System.assertEquals('{"active":true,"threshold":5,"original_status":"New","new_status":"Accepted"}', updateStatusSettings.Value__c);

			System.assertNotEquals(null, pageRefRes2, 'Method should return PageReference instance');
		}
		Test.stopTest();
	}

}