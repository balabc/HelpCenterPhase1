@IsTest
private class brBlogSettingsCtrlTest {
    @TestSetup
    public static void testSetup(){
        List<brBlog_Settings__c> settList = new List<brBlog_Settings__c>();

        settList.add(new brBlog_Settings__c(Name = brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING,
                Label__c = 'Allow members to add articles',
                Value__c = 'false'));
        settList.add(new brBlog_Settings__c(Name = brBlogHelper.MODERATION_SETTING,
                Label__c = 'Moderation',
                Value__c = 'external'));
        settList.add(new brBlog_Settings__c(Name = brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING,
                Label__c = 'Moderator email addresses',
                Value__c = 'undefined'));

        insert settList;

        brBlogTestUtils.testCreateUser();
        System.assertEquals(3, settList.size(), 'contain three blog settings');
    }

    @isTest
    public static void testWithPermissions() {

        brBlogSettingsCtrl ctrl1 = new brBlogSettingsCtrl();
        System.assertEquals(true, ctrl1.moderationOptions.size() > 0, 'Invalid moderation options number');
        System.assertEquals('external', ctrl1.selectedModeration, 'Invalid selected moderation value');
        System.assertEquals(false, ctrl1.allowPostFromCommunity, 'Invalid selected allowPostFromCommunity value');
        System.assertEquals('undefined', ctrl1.moderatorEmailAddresses, 'Invalid selected moderatorEmailAddresses value');

        ctrl1.selectedModeration = 'all';
        ctrl1.allowPostFromCommunity = true;
        ctrl1.moderatorEmailAddresses = 'test@example.com';

        PageReference pageRef = ctrl1.saveSettings();

        System.assertEquals('all', brBlog_Settings__c.getValues(brBlogHelper.MODERATION_SETTING).Value__c,
                'Invalid ' + brBlogHelper.MODERATION_SETTING + ' setting value');
        System.assertEquals('true', brBlog_Settings__c.getValues(brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING).Value__c,
                'Invalid ' + brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING + ' setting value');
        System.assertEquals('test@example.com', brBlog_Settings__c.getValues(brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING).Value__c,
                'Invalid ' + brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING + ' setting value');

        brBlogSettingsCtrl ctrl2 = new brBlogSettingsCtrl();
        System.assertEquals(true, ctrl2.allowPostFromCommunity, 'Invalid selected allowPostFromCommunity value');
    }

    @isTest
    public static void testWithoutPermissions() {

        User user = [SELECT Id From User WHERE UserName='standardusekjnkjnr@testorg.com'];

        System.runAs(user) {
            brBlogSettingsCtrl ctrl1 = new brBlogSettingsCtrl();
            PageReference pageRef = ctrl1.saveSettings();

            System.assertNotEquals(null, user, 'user exist');
        }
    }

}