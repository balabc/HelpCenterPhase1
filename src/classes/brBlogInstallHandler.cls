global class brBlogInstallHandler implements InstallHandler {

    global void onInstall(InstallContext context) {
        if(context.previousVersion() == null) {
            //first install
        }

        this.checkConfigurationValues();
    }


    private void checkConfigurationValues() {

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_Settings__c', null)
                || !brBlogHelper.performAccessCheck('create', 'brBlog_Settings__c', new List<String>{'Label__c', 'Value__c'})){
            return;
        }

        List<brBlog_Settings__c> settList = new List<brBlog_Settings__c>();
        List<brBlog_Settings__c> allowPostFromCommunitySetting = [SELECT Id FROM brBlog_Settings__c
                                                                            WHERE Name = :brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING];
        List<brBlog_Settings__c> moderationSetting = [SELECT Id FROM brBlog_Settings__c
                                                                            WHERE Name = :brBlogHelper.MODERATION_SETTING];
        List<brBlog_Settings__c> moderatorEmailAddressesSetting = [SELECT Id FROM brBlog_Settings__c
                                                                            WHERE Name = :brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING];


        if (allowPostFromCommunitySetting.size() == 0) {
            settList.add(new brBlog_Settings__c(Name = brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING,
                    Label__c = 'Allow members to add articles',
                    Value__c = 'false'));
        }

        if (moderationSetting.size() == 0) {
            settList.add(new brBlog_Settings__c(Name = brBlogHelper.MODERATION_SETTING,
                    Label__c = 'Moderation',
                    Value__c = 'external'));
        }

        if (moderatorEmailAddressesSetting.size() == 0) {
            settList.add(new brBlog_Settings__c(Name = brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING,
                    Label__c = 'Moderator email addresses',
                    Value__c = 'undefined'));
        }


        try {
            insert settList;
        } catch (DmlException e) {
            System.debug('Error '+ e.getMessage());
        }

    }
}