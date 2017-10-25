@isTest
private class brBlogArticleTriggerTest {

    @testSetup 
    static void insertArticle() {
        brBlog_article__c article = new brBlog_article__c();
        article.Name = 'What is Salesforce';
        article.Body__c = 'Salesforce  is an American cloud computing company';

        insert article;

        System.assertEquals('What is Salesforce', article.Name, 'get first article name value');
    }

    @isTest
    static void testDateTimeOnInsertWithDraftFalse() {   

        Test.startTest();
        DateTime publishedDate = [SELECT Published_Date__c FROM brBlog_article__c].Published_Date__c;
        Test.stopTest();

        System.assertNotEquals(null, publishedDate, 'result should contain not null datetime');
    }

    @isTest
    static void testDateTimeOnInsertWithDraftTrue() {

        brBlog_article__c article = new brBlog_article__c();

        article.Name = 'What is Salesforce';
        article.Body__c = 'Salesforce  is an American cloud computing company headquartered in San Francisco, California.';
        article.Draft__c = true;

        Test.startTest();
        insert article;
        Test.stopTest();

        List<brBlog_article__c> articles = [SELECT Published_Date__c FROM brBlog_article__c LIMIT 150];

        System.assertEquals(null, articles.get(1).Published_Date__c, 'result should contain not null datetime');
    }

    @isTest
    static void testDateTimeOnUpdateWithDraftFalse() {

        List<brBlog_article__c> articles = [SELECT Published_Date__c FROM brBlog_article__c LIMIT 150];
        articles.get(0).Published_Date__c = null;

        Test.startTest();
        update articles.get(0);
        Test.stopTest();

        DateTime publishedDate = [SELECT Published_Date__c FROM brBlog_article__c].Published_Date__c;

        System.assertNotEquals(null, publishedDate, 'result should contain not null datetime');
    }

    @isTest
    static void testDateTimeOnUpdateWithDraftTrue() {
        
        List<brBlog_article__c> articles = [SELECT Published_Date__c FROM brBlog_article__c LIMIT 150];

        articles.get(0).Published_Date__c = null;
        articles.get(0).Draft__c = true;

        Test.startTest();
        update articles.get(0);
        Test.stopTest();

        DateTime publishedDate = [SELECT Published_Date__c FROM brBlog_article__c].Published_Date__c;

        System.assertEquals(null, publishedDate, 'result should contain not null datetime');
    }
}