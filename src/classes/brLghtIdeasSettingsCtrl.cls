public with sharing class brLghtIdeasSettingsCtrl {
    public List<SelectOption> zonesOptions {get; set;}
    public List<SelectOption> ideaStatusesOption {get;set;}
    public String selectedZone {get; set;}
    public String statusToChange {get;set;} //maybe 'statusUpdateFrom' is better name?
    public String nextStatus {get;set;} //maybe 'statusUpdateTo' is better name?
    public String limitForStatus {get;set;} //maybe 'statusUpdateThreshold' is better name?
    public Boolean isStatusUpdateEnabled {get;set;} //maybe 'enableStatusUpdate' is better name?
    public String orgWideEmailId {get; set;}

    private brLghtIdeasSettings__c settingsAutoStatusUpdate;


    public brLghtIdeasSettingsCtrl() {
        Schema.DescribeSObjectResult settingsObjDescribe = brLghtIdeasSettings__c.sObjectType.getDescribe();
        Schema.DescribeSObjectResult communityObjDescribe = Community.sObjectType.getDescribe();

        if (!communityObjDescribe.isAccessible() || !settingsObjDescribe.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'You don\'t have appropriate permissions to edit this settings'));
            return;
        }

        initSettingsValues();

    }

    public void initSettingsValues() {
        selectedZone = ' ';
        zonesOptions = new List<SelectOption>();
        ideaStatusesOption = new List<SelectOption>();
        isStatusUpdateEnabled = false;
        limitForStatus = '';
        statusToChange= '';
        nextStatus = '';
        orgWideEmailId = '';

        zonesOptions.add(new SelectOption(' ', ' '));
        ideaStatusesOption.add(new SelectOption(' ', ' '));

        for (Community zone : [SELECT Id, Name FROM Community LIMIT 50]) {
            zonesOptions.add(new SelectOption(zone.Name, zone.Name));
        }

        if (zonesOptions.size() <= 1) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'Current Organization doesn\'t have any Ideas Zone setup. Please create Ideas Zone to continue'));
        }

        try {
            brLghtIdeasSettings__c communityRow = [SELECT Value__c FROM brLghtIdeasSettings__c WHERE Name = 'community'];
            selectedZone = communityRow.Value__c;

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'Please create a custom settings record (Name=\'community\') within LghtIdeasSettings object'));
            System.debug('LghtIdeasSettingsCtrl: ' + e.getMessage());
        }

        Schema.DescribeFieldResult statusFieldDescrine = Schema.Idea.Status.getDescribe();
        List<Schema.PicklistEntry> picklistValues = statusFieldDescrine.getPicklistValues();

        for (Schema.PicklistEntry picklistItem : picklistValues) {
            ideaStatusesOption.add(new SelectOption(picklistItem.getLabel(), picklistItem.getValue()));
        }

        Map<String, String> statusUpdateSettings = brLghtIdeasHelper.getStatusUpdateSettings();

        if (statusUpdateSettings != null) {
            isStatusUpdateEnabled = Boolean.valueOf(statusUpdateSettings.get('active'));
            limitForStatus = statusUpdateSettings.get('threshold');
            statusToChange = statusUpdateSettings.get('original_status');
            nextStatus = statusUpdateSettings.get('new_status');
        }

        try {
            brLghtIdeasSettings__c emailIdRow = [SELECT Value__c FROM brLghtIdeasSettings__c WHERE Name = 'orgwide_email_id'];
            orgWideEmailId = emailIdRow.Value__c;

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'Please create a custom settings record (Name=\'orgwide_email_id\') within LghtIdeasSettings object'));
        }

    }


    public PageReference saveSettings() {
        Decimal threshold = 0;

        if (!Schema.sObjectType.brLghtIdeasSettings__c.fields.Value__c.isUpdateable()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                    'You don\'t have perrmissions for this action'));
            return null;
        }

        if (String.isBlank(selectedZone)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Failed to save. Ideas Zone can not be empty'));
            return null;
        }

        try {
            brLghtIdeasSettings__c communityRow = [SELECT Value__c FROM brLghtIdeasSettings__c WHERE Name = 'community' LIMIT 1];

            communityRow.Value__c = selectedZone;

            if (String.isNotBlank(limitForStatus)) {
                threshold = Decimal.valueOf(limitForStatus);
            }

            brLghtIdeasSettings__c settingsAutoStatusUpdate = [SELECT Value__c  FROM brLghtIdeasSettings__c WHERE Name = 'status_update' LIMIT 1];
            settingsAutoStatusUpdate.Value__c = '{"active":' + isStatusUpdateEnabled + ',"threshold":' + String.valueOf(threshold) + ',' +
                    '"original_status":"' + statusToChange + '",' +
                    '"new_status":"' + nextStatus + '"}';

            brLghtIdeasSettings__c emailIdRow = [SELECT Value__c FROM brLghtIdeasSettings__c WHERE Name = 'orgwide_email_id'];
            emailIdRow.Value__c = orgWideEmailId;

            List<brLghtIdeasSettings__c> settings = new List<brLghtIdeasSettings__c>{communityRow, settingsAutoStatusUpdate, emailIdRow};

            update settings;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Community settings saved successfully'));

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Failed to save ' + e.getMessage()));
            System.debug('LghtIdeasSettingsCtrl::saveSettings: ' + e.getMessage());

            return null;
        }

        return ApexPages.currentPage();
    }

}