@isTest
private class brBlogArticleCreateFormCtrlTest {

    @testSetup 
    static void insertCategories() {
        List<brBlog_Category__c> categories = brBlogTestUtils.testCreateCategories();
        brBlogTestUtils.testCreateUser();
        brBlogTestUtils.testCreateExternalUser();

        System.assertEquals('SalesforceCategory0', categories[0].Name, 'get first category name value');
    }
    
    @isTest
    static void testGetCategories() {
        brBlog_Category__c newCategory = new brBlog_Category__c(Name = 'Apex');

        insert newCategory;

        Test.startTest();
        List<brBlog_Category__c> allCategories = brBlogArticleCreateFormCtrl.getCategories();
        Test.stopTest();

        System.assertEquals( 'Apex', allCategories.get(0).Name, 'result should contain not null and order by name');
        System.assertEquals('SalesforceCategory0', allCategories.get(1).Name, 'result should contain not null and order by name');
        System.assertEquals('SalesforceCategory1', allCategories.get(2).Name, 'result should contain not null and order by name');
        System.assertEquals('SalesforceCategory2', allCategories.get(3).Name, 'result should contain not null and order by name');
    }

    @isTest
    static void testSaveArticleWithExternalModerationSettingAndStandardType() {

        User user = [SELECT Id From User WHERE UserName='standardusekjnkjnr@testorg.com'];

        brBlog_Settings__c settingMembers = new brBlog_Settings__c();
        settingMembers.Name = brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING;
        settingMembers.Value__c = 'true';
        insert settingMembers;

        brBlog_Settings__c settingModeration = new brBlog_Settings__c();
        settingModeration.Name = brBlogHelper.MODERATION_SETTING;
        settingModeration.Value__c = 'external';
        insert settingModeration;

        brBlog_Settings__c ModeratorEmailAddresses = new brBlog_Settings__c();
        ModeratorEmailAddresses.Name = brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING;
        ModeratorEmailAddresses.Value__c = 'adition2012@mail.ru, dmitry.dubnovitsky@gmail.com';
        insert ModeratorEmailAddresses;

        brBlogTestUtils.testCreateTags();

        String tagsName = 'Apex, java, SalesforceTag1, SalesforceTag0';
        String categories = 'SalesforceCategory0;SalesforceCategory1';

        Map<String,String> article = new Map<String,String>();
        article.put('name', 'What is Salesforce');
        article.put('body', 'Salesforce  is an American cloud computing company');
        article.put('shortBody', 'Salesforce company');

        System.runAs(user) {
            brBlogTestUtils.testCreateEmailTemplate();
            brBlogArticleCreateFormCtrl.saveArticle(article, tagsName, categories);

            List<brBlog_Tag__c> allTags = [SELECT Name FROM brBlog_Tag__c LIMIT 150];

            System.assertEquals(5, allTags.size(), 'result should contain old and new tags');
            System.assertEquals('Apex', allTags.get(3).Name, 'result should contain not null');
            System.assertEquals('java', allTags.get(4).Name, 'result should contain not null');

            List<brBlog_Tag_Assignment__c> tagsAssignment = [SELECT Blog_Article__c
                                                                        FROM brBlog_Tag_Assignment__c LIMIT 150];

            System.assertEquals(4, tagsAssignment.size(), 'result should contain count current tags');

            List<brCategory_assignment__c> categoriesAssignment = [SELECT Blog_Category__c
                                                                        FROM brCategory_assignment__c LIMIT 150];
            System.assertEquals(2, categoriesAssignment.size(), 'result should contain count current categories');

            List<brBlog_article__c> articles = [SELECT Name, Draft__c FROM brBlog_article__c LIMIT 150];

            System.assertEquals(false, articles[0].Draft__c);
        }
    }

    @isTest
    static void testSaveArticleWithExternalModerationSettingWithoutStandardType() {

        User user = [SELECT Id From User WHERE UserName='externaluser@testorg.com'];

        brBlog_Settings__c settingMembers = new brBlog_Settings__c();
        settingMembers.Name = brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING;
        settingMembers.Value__c = 'true';
        insert settingMembers;

        brBlog_Settings__c settingModeration = new brBlog_Settings__c();
        settingModeration.Name = brBlogHelper.MODERATION_SETTING;
        settingModeration.Value__c = 'external';
        insert settingModeration;

        brBlog_Settings__c ModeratorEmailAddresses = new brBlog_Settings__c();
        ModeratorEmailAddresses.Name = brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING;
        ModeratorEmailAddresses.Value__c = 'adition2012@mail.ru, dmitry.dubnovitsky@gmail.com';
        insert ModeratorEmailAddresses;

        Map<String,String> article = new Map<String,String>();
        article.put('name', 'What is Salesforce');
        article.put('body', 'Salesforce  is an American cloud computing company');
        article.put('shortBody', 'Salesforce company');

        System.runAs(user) {
        brBlogTestUtils.testCreateEmailTemplate();
        Boolean result = brBlogArticleCreateFormCtrl.getAllowCreateArticle();
        System.assertEquals(true, result);

        String categories = 'SalesforceCategory0;SalesforceCategory1';

        brBlogArticleCreateFormCtrl.saveArticle(article, null, categories);

        List<brBlog_article__c> articles = [SELECT Name, Draft__c FROM brBlog_article__c LIMIT 150];

        System.assertEquals(1, articles.size());

        System.assertEquals(true, articles[0].Draft__c);
      }
    }

    @isTest
    static void testCreateArticleNotGuestUserWithAllowMembersAndAllModerationSettings() {

        User user = [SELECT Id From User WHERE UserName='standardusekjnkjnr@testorg.com'];

        brBlog_Settings__c settingMembers = new brBlog_Settings__c();
        settingMembers.Name = brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING;
        settingMembers.Value__c = 'true';
        insert settingMembers;

        brBlog_Settings__c settingModeration = new brBlog_Settings__c();
        settingModeration.Name = brBlogHelper.MODERATION_SETTING;
        settingModeration.Value__c = 'all';
        insert settingModeration;

        brBlog_Settings__c ModeratorEmailAddresses = new brBlog_Settings__c();
        ModeratorEmailAddresses.Name = brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING;
        ModeratorEmailAddresses.Value__c = 'adition2012@mail.ru, dmitry.dubnovitsky@gmail.com';
        insert ModeratorEmailAddresses;

        Map<String,String> article = new Map<String,String>();
        article.put('name', 'What is Salesforce');
        article.put('body', 'Salesforce  is an American cloud computing company');
        article.put('shortBody', 'Salesforce company');

        System.runAs(user) {
        brBlogTestUtils.testCreateEmailTemplate();
        Boolean result = brBlogArticleCreateFormCtrl.getAllowCreateArticle();
        System.assertEquals(true, result);
        
        String categories = 'SalesforceCategory0;SalesforceCategory1';

        brBlogArticleCreateFormCtrl.saveArticle(article, null, categories);

        List<brBlog_article__c> articles = [SELECT Name, Draft__c FROM brBlog_article__c LIMIT 150];

        System.assertEquals(1, articles.size());

        System.assertEquals(true, articles[0].Draft__c);
      }
    }

    @isTest
    static void testCreateArticleNotGuestUserWithPermissionAssignmentAndNoneModerationSetting() {

        User user = [SELECT Id From User WHERE UserName='standardusekjnkjnr@testorg.com'];

        brBlog_Settings__c settingMembers = new brBlog_Settings__c();
        settingMembers.Name = brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING;
        settingMembers.Value__c = 'false';
        insert settingMembers;

        brBlog_Settings__c settingModeration = new brBlog_Settings__c();
        settingModeration.Name = brBlogHelper.MODERATION_SETTING;
        settingModeration.Value__c = 'none';
        insert settingModeration;

        brBlog_Settings__c ModeratorEmailAddresses = new brBlog_Settings__c();
        ModeratorEmailAddresses.Name = brBlogHelper.MODERATOR_EMAIL_ADDRESSES_SETTING;
        ModeratorEmailAddresses.Value__c = 'adition2012@mail.ru, dmitry.dubnovitsky@gmail.com';
        insert ModeratorEmailAddresses;

        Map<String,String> article = new Map<String,String>();
        article.put('name', 'What is Salesforce');
        article.put('body', 'Salesforce  is an American cloud computing company');
        article.put('shortBody', 'Salesforce company');

        System.runAs(user) {
            brBlogTestUtils.testCreateEmailTemplate();
            String psId = [SELECT Id, Name FROM PermissionSet WHERE Name = 'AC_Blog_Author'].Id;
        
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = psId,
                                                                    AssigneeId = UserInfo.getUserId());

            insert psa;

            Boolean result = brBlogArticleCreateFormCtrl.getAllowCreateArticle();
            System.assertEquals(true, result);

            String categories = 'SalesforceCategory0;SalesforceCategory1';

            brBlogArticleCreateFormCtrl.saveArticle(article, null, categories);

            List<brBlog_article__c> articles = [SELECT Name, Draft__c FROM brBlog_article__c LIMIT 150];

            System.assertEquals(1, articles.size());

            System.assertEquals(false, articles[0].Draft__c);
        }
    }

    @isTest
    static void testCreateArticleNotGuestUserWithoutSettingWithoutPermissionAssignment() {

        User user = [SELECT Id From User WHERE UserName='standardusekjnkjnr@testorg.com'];

        brBlog_Settings__c setting = new brBlog_Settings__c();
        setting.Name = brBlogHelper.ALLOW_MEMBERS_ADD_ARTICLES_SETTING;
        setting.Value__c = 'false';
        insert setting;

        Map<String,String> article = new Map<String,String>();
        article.put('name', 'What is Salesforce');
        article.put('body', 'Salesforce  is an American cloud computing company');
        article.put('shortBody', 'Salesforce company');

        System.runAs(user) {
            Boolean result = brBlogArticleCreateFormCtrl.getAllowCreateArticle();
            System.assertEquals(false, result);

            String categories = 'SalesforceCategory0;SalesforceCategory1';

            brBlogArticleCreateFormCtrl.saveArticle(article, null, categories);

            List<brBlog_article__c> articles = [SELECT Name, Draft__c FROM brBlog_article__c LIMIT 150];

            System.assertEquals(0, articles.size());
        }
    }
}