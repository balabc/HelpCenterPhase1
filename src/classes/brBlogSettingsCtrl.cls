public with sharing class brBlogSettingsCtrl {
    public List<SelectOption> moderationOptions {get; set;}
    public String selectedModeration {get; set;}
    public String moderatorEmailAddresses {get; set;}
    public Boolean allowPostFromCommunity {get; set;}

    public brBlogSettingsCtrl() {

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_Settings__c', new List<String>{'Label__c', 'Value__c'})
                || !brBlogHelper.performAccessCheck('edit', 'brBlog_Settings__c', new List<String>{'Value__c'})){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                    'You don\'t have appropriate permissions to edit this settings'));
            return;
        }

        populateSettings();
    }

    public void populateSettings() {
        selectedModeration = '';
        moderationOptions = new List<SelectOption>();
        moderationOptions.add(new SelectOption('', ''));
        moderationOptions.add(new SelectOption('all', 'All posts'));
        moderationOptions.add(new SelectOption('external', 'Posts by community users only'));
        moderationOptions.add(new SelectOption('none', 'Disabled'));

        try {
            selectedModeration = brBlog_Settings__c.getValues(brBlogHelper.MODERATION_SETTING).Value__c;

            moderatorEmailAddresses = brBlog_Settings__c.getValues(brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING).Value__c;

            String allowPostFromCommunityValue = brBlog_Settings__c.getValues(brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING).Value__c;

            if(allowPostFromCommunityValue == 'true') {
                allowPostFromCommunity = true;
            }
            else {
                allowPostFromCommunity = false;
            }
        }
        catch (Exception e) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
            //        'Please create a custom settings record (Name=\'community\') within LghtIdeasSettings object'));
            System.debug('BlogSettingsCtrl: ' + e.getMessage());
        }
    }


    public PageReference saveSettings() {
        if (selectedModeration == '') return null;

        if (!Schema.sObjectType.brBlog_Settings__c.fields.Value__c.isUpdateable()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                    'You don\'t have perrmissions for this action'));
            return null;
        }

        List<brBlog_Settings__c> settings = new List<brBlog_Settings__c>();

        try {
            for (brBlog_Settings__c setting: [SELECT Name FROM brBlog_Settings__c LIMIT 150]) {
                if(setting.Name == brBlogHelper.MODERATION_SETTING) {
                    setting.Value__c = selectedModeration;
                    settings.add(setting);
                }
                else if(setting.Name == brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING) {
                    setting.Value__c = allowPostFromCommunity ? 'true' : 'false';
                    settings.add(setting);
                }
                 else if(setting.Name == brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING) {
                    setting.Value__c = moderatorEmailAddresses;
                    settings.add(setting);
                }
            }

            if(settings.size() > 0) {
                update settings;
            }

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Saved successfully'));
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Failed to save'));
            System.debug('BrEventsSettingsCtrl::saveSettings: ' + e.getMessage());
            return null;
        }

        return ApexPages.currentPage();

    }
}