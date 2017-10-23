@IsTest
private class brBlogInstallHandlerTest {

    @isTest
    static void testOnInstall() {
        brBlogInstallHandler installHandler = new brBlogInstallHandler();
        Test.testInstall(installHandler, null);

        List<brBlog_Settings__c> settList = new List<brBlog_Settings__c>();
        List<brBlog_Settings__c> allowPostFromCommunitySetting = [SELECT Value__c FROM brBlog_Settings__c
        WHERE Name = :brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING];
        List<brBlog_Settings__c> moderationSetting = [SELECT Value__c FROM brBlog_Settings__c
        WHERE Name = :brBlogHelper.MODERATION_SETTING];
        List<brBlog_Settings__c> moderatorEmailAddressesSetting = [SELECT Value__c FROM brBlog_Settings__c
        WHERE Name = :brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING];


        if (allowPostFromCommunitySetting.size() == 1) {
            System.assertEquals('false', allowPostFromCommunitySetting[0].Value__c, 'Invalid value');
        }
        else {
            System.assertEquals(true, false, 'Settings value has not been created');
        }

        if (moderationSetting.size() == 1) {
            System.assertEquals('external', moderationSetting[0].Value__c, 'Invalid value');
        }
        else {
            System.assertEquals(true, false, 'Settings value has not been created');
        }

        if (moderatorEmailAddressesSetting.size() == 1) {
            System.assertEquals('undefined', moderatorEmailAddressesSetting[0].Value__c, 'Invalid value');
        }
        else {
            System.assertEquals(true, false, 'Settings value has not been created');
        }
    }
}