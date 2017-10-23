@IsTest
public class brBlogTestUtils {
    public static List<brBlog_article__c> testCreateArticles() {
        List<brBlog_article__c> articles = new List<brBlog_article__c>();

        for (Integer i = 0; i < 3; i++) {

            articles.add(new brBlog_article__c(Name = 'What is Salesforce',
                    Short_Body__c = 'Salesforce  is an American cloud computing company',
                    Draft__c = false,
                    Published_Date__c = Datetime.newInstance(2016, 10, 15, 12, 30, 0)
            ));
        }

        insert articles;

        System.assertEquals('What is Salesforce', articles[0].Name, 'get first article name value');

        return articles;
    }

    public static List<brBlog_Tag__c> testCreateTags() {
        List<brBlog_Tag__c> tags = new List<brBlog_Tag__c>();

        for (Integer i = 0; i < 3; i++) {
            tags.add(new brBlog_Tag__c(Name = 'SalesforceTag' + i));
        }

        insert tags;

        System.assertEquals('SalesforceTag0', tags[0].Name, 'get first tag name value');

        return tags;
    }

    public static List<brBlog_Category__c> testCreateCategories() {
        List<brBlog_Category__c> categories = new List<brBlog_Category__c>();

        for (Integer i = 0; i < 3; i++) {
            categories.add(new brBlog_Category__c(Name = 'SalesforceCategory' + i));
        }

        insert categories;

        System.assertEquals('SalesforceCategory0', categories[0].Name, 'get first category name value');

        return categories;
    }

    public static void testCreateTagsAssignment() {
        List<brBlog_Tag__c> tags = [SELECT Id, Name FROM brBlog_Tag__c LIMIT 150];
        List<brBlog_article__c> articles = [SELECT Id, Name FROM brBlog_article__c LIMIT 150];
        List<brBlog_Tag_Assignment__c> tagsAssignment = new List<brBlog_Tag_Assignment__c>();

        for (brBlog_article__c article : articles) {
            for (brBlog_Tag__c tag : tags) {
                tagsAssignment.add(new brBlog_Tag_Assignment__c(Blog_Article__c = article.Id,
                        Blog_Tag__c = tag.Id));
            }
        }

        insert tagsAssignment;

        System.assertNotEquals(null, tagsAssignment, 'tags assignment exist');
    }

    public static void testCreateCategoriesAssignment() {
        List<brBlog_article__c> articles = [SELECT Id, Name FROM brBlog_article__c LIMIT 150];
        List<brBlog_Category__c> categories = [SELECT Id, Name, Friendly_URL__c
        FROM brBlog_Category__c LIMIT 150];

        List<brCategory_assignment__c> categoriesAssignment = new List<brCategory_assignment__c>();

        for (brBlog_article__c article : articles) {
            for (brBlog_Category__c category : categories) {
                categoriesAssignment.add(new brCategory_assignment__c(Blog_Article__c = article.Id,
                        Blog_Category__c = category.Id));
            }
        }

        insert categoriesAssignment;

        System.assertNotEquals(null, categoriesAssignment, 'categories assignment exist');
    }

    public static void testCreateUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User user = new User(Alias = 'standt', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='standardusekjnkjnr@testorg.com');
        insert user;
        assignPermissionSet(user.Id, 'AC_Blog_User');

        System.assertEquals('standardusekjnkjnr@testorg.com', user.Username, 'get user name value');
    }

    public static void testCreateExternalUser() {
        Account account = new Account(Name ='Graz') ;
        insert account;

        Contact contact = new Contact(LastName = 'Barry', AccountId = account.Id);
        insert contact;

        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User'];
        User user = new User(Alias = 'standt', Email='externaluser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id, ContactId = contact.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='externaluser@testorg.com');

        insert user;
        assignPermissionSet(user.Id, 'AC_Blog_User');

        System.assertEquals('externaluser@testorg.com', user.Username, 'get user name value');
    }

    @future
    public static void assignPermissionSet(Id userId, String permissionSet) {
        PermissionSet ps = [SELECT Id From PermissionSet WHERE Name = :permissionSet];
        insert new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = ps.Id);

        System.assertNotEquals(null, ps, 'permission set not null');
    }

    public static void testCreateEmailTemplate() {

        EmailTemplate emailTemplate = new EmailTemplate (TemplateType= 'Text', FolderId = UserInfo.getUserId(),
                Name = 'Blog Moderation', Body = '{!User.FirstName} {!User.LastName} {!Blog_article__c.Link}');
        insert emailTemplate;

        System.assertNotEquals(null, emailTemplate, 'not null email template object');
    }
}