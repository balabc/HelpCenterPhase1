public with sharing class BrEventsSettingsCtrl {
    public List<SelectOption> imageSourceOptions {get; set;}
    public String selectedImageSource {get; set;}

    public BrEventsSettingsCtrl() {
        selectedImageSource = '';
        imageSourceOptions = new List<SelectOption>();

        imageSourceOptions.add(new SelectOption('', ''));
        imageSourceOptions.add(new SelectOption('attachments', 'Attachments'));
        imageSourceOptions.add(new SelectOption('files', 'Chatter Files'));

        if (!BrEventsHelper.performAccessCheck('read', 'BrEvents_Settings__c', null)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    Label.msg_no_appr_permissions));
            return;
        }

        try {
            BrEvents_Settings__c imageSourceRow = [SELECT Value__c FROM BrEvents_Settings__c WHERE Name = 'image source'];
            selectedImageSource = imageSourceRow.Value__c;
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    Label.msg_custom_setting_image_source_for_events_obj));
            System.debug('BrEventsSettingsCtrl: ' + e.getMessage());
        }
    }


    public PageReference saveSettings() {
        if (selectedImageSource == '') return null;

        try {
            BrEvents_Settings__c imageSourceRow = [SELECT Id FROM BrEvents_Settings__c WHERE Name = 'image source'];
            imageSourceRow.Value__c = selectedImageSource;

            if (Schema.sObjectType.BrEvents_Settings__c.fields.Value__c.isUpdateable()) {
                update imageSourceRow;

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.msg_saved_successfully));
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                        Label.msg_no_permissions));
            }
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, Label.msg_failed_to_save));
            System.debug('BrEventsSettingsCtrl::saveSettings: ' + e.getMessage());
            return null;
        }
        return ApexPages.currentPage();

    }
}