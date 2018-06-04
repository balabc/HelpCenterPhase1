@isTest
private class brLghtIdeasInstallHandlerTest {
	@isTest
	static void testOnInstall() {
		User testUser = brTestDataFactory.createTestStandardProfileUser();

		System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');
		Test.startTest();

		System.runAs(testUser) {
			brLghtIdeasInstallHandler installHandler = new brLghtIdeasInstallHandler();
			Test.testInstall(installHandler, null);

			List<brLghtIdeasSettings__c> settingsCommunity = [SELECT Value__c FROM brLghtIdeasSettings__c WHERE Name = 'community'];
			List<brLghtIdeasSettings__c> settingsAutoStatusUpdate = [SELECT Id,Value__c FROM brLghtIdeasSettings__c WHERE Name = 'status_update'];
			List<brLghtIdeasSettings__c> settingsEmailNotification = [SELECT Id,Value__c FROM brLghtIdeasSettings__c WHERE Name = 'email_notification'];

			if (settingsCommunity.size() == 1) {
				System.assertEquals(settingsCommunity[0].Value__c, 'undefined', 'Invalid value');
			} else {
				System.assertEquals(false, true, 'Settings value has not been created');
			}

			if (settingsAutoStatusUpdate.size() == 1) {
				System.assertEquals(settingsAutoStatusUpdate[0].Value__c, '{"active":false,"threshold":"","original_status":"","new_status":""}', 'Invalid value');
			} else {
				System.assertEquals(false, true, 'Settings value has not been created');
			}

			if (settingsEmailNotification.size() == 1) {
				System.assertEquals(settingsEmailNotification[0].Value__c, '{"active":false,"template":"NewCommentNotificationToIdeaOwner"}', 'Invalid value');
			} else {
				System.assertEquals(false, true, 'Settings value has not been created');
			}
		}
		Test.stopTest();
	}
}