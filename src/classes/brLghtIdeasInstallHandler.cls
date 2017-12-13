global class brLghtIdeasInstallHandler implements InstallHandler {

	global void onInstall(InstallContext context) {
		if(context.previousVersion() == null) {
			//first install
		}

		this.checkConfigurationValues();
	}


	private void checkConfigurationValues() {
		Schema.DescribeSObjectResult settingsDescribe = brLghtIdeasSettings__c.sObjectType.getDescribe();

		if (!settingsDescribe.isAccessible() || !settingsDescribe.isCreateable()) return;

		List<brLghtIdeasSettings__c> settingsCommunity = [SELECT Id FROM brLghtIdeasSettings__c WHERE Name = 'community'];
		List<brLghtIdeasSettings__c> settingsAutoStatusUpdate = [SELECT Id FROM brLghtIdeasSettings__c WHERE Name = 'status_update'];
		List<brLghtIdeasSettings__c> settingsEmailNotification = [SELECT Id FROM brLghtIdeasSettings__c WHERE Name = 'email_notification'];
		List<brLghtIdeasSettings__c> settingsOrgWideEmailId = [SELECT Id FROM brLghtIdeasSettings__c WHERE Name = 'orgwide_email_id'];
		List<brLghtIdeasSettings__c> settList = new List<brLghtIdeasSettings__c>();

        if (settingsCommunity.size() == 0) {
            settList.add(new brLghtIdeasSettings__c(Name = 'community', Label__c = 'Ideas Zone Name', Value__c = 'undefined'));
        }

        if (settingsAutoStatusUpdate.size() == 0) {
            settList.add(new brLghtIdeasSettings__c(Name = 'status_update', Label__c = 'Status update',
                    Description__c = 'Conditions for status update',
                    Value__c = '{"active":false,"threshold":"","original_status":"","new_status":""}'));
        }

        if (settingsEmailNotification.size() == 0) {
            settList.add(new brLghtIdeasSettings__c(Name = 'email_notification', Label__c = 'Email Notification',
                    Description__c = 'Conditions for email notifications',
                    Value__c = '{"active":false,"template":"NewCommentNotificationToIdeaOwner"}'));
        }

		if (settingsOrgWideEmailId.size() == 0) {
			settList.add(new brLghtIdeasSettings__c(Name = 'orgwide_email_id', Label__c = 'Org-Wide Email Address ID',
					Description__c = 'Org-Wide Email Address ID for email notifications',
					Value__c = ''));
		}

		try {
			insert settList;
		} catch (DmlException e) {
			System.debug('Error '+ e.getMessage());
		}

	}
}
