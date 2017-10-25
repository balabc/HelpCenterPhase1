@isTest
private class brBlogArticlesListCtrlTest {

    @testSetup 
    static void saveData() {
        List<brBlog_article__c> articles = brBlogTestUtils.testCreateArticles();
        List<brBlog_Category__c> categories = brBlogTestUtils.testCreateCategories();
        brBlogTestUtils.testCreateCategoriesAssignment();

        System.assertEquals('What is Salesforce', articles[0].Name, 'get first article name value');
        System.assertEquals('SalesforceCategory0', categories[0].Name, 'get first category name value');
    }

    @isTest
    static void testWithoutFilterData() {

        brBlogTestUtils.testCreateTags();
        brBlogTestUtils.testCreateTagsAssignment();
     
        Test.startTest();
        List<brBlogArticleWrapper> articlesWrapped = brBlogArticlesListCtrl.getArticles(null, 1, 3);
        Test.stopTest();

        System.assertEquals('What is Salesforce', articlesWrapped.get(0).item.Name, 'result should contain name in article');
        System.assertEquals('What is Salesforce', articlesWrapped.get(1).item.Name, 'result should contain name in article');
        System.assertEquals('What is Salesforce', articlesWrapped.get(2).item.Name, 'result should contain name in article');
        
        System.assertEquals('Salesforce  is an American cloud computing company', articlesWrapped.get(0).item.Short_Body__c,
                             'result should contain body in article');
        System.assertEquals('Salesforce  is an American cloud computing company', articlesWrapped.get(1).item.Short_Body__c,
                             'result should contain body in article');
        System.assertEquals('Salesforce  is an American cloud computing company', articlesWrapped.get(2).item.Short_Body__c,
                             'result should contain body in article');

        System.assertEquals('SalesforceTag0', articlesWrapped.get(0).tags.get(0).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag1', articlesWrapped.get(0).tags.get(1).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag2', articlesWrapped.get(0).tags.get(2).Name, 'result should contain tag in article');

        System.assertEquals('SalesforceTag0', articlesWrapped.get(1).tags.get(0).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag1', articlesWrapped.get(1).tags.get(1).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag2', articlesWrapped.get(1).tags.get(2).Name, 'result should contain tag in article');

        System.assertEquals('SalesforceTag0', articlesWrapped.get(2).tags.get(0).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag1', articlesWrapped.get(2).tags.get(1).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag2', articlesWrapped.get(2).tags.get(2).Name, 'result should contain tag in article');

        System.assertEquals('SalesforceCategory0', articlesWrapped.get(0).categories.get(0).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory1', articlesWrapped.get(0).categories.get(1).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory2', articlesWrapped.get(0).categories.get(2).Name, 'result should contain category in article');

        System.assertEquals('SalesforceCategory0', articlesWrapped.get(1).categories.get(0).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory1', articlesWrapped.get(1).categories.get(1).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory2', articlesWrapped.get(1).categories.get(2).Name, 'result should contain category in article');

        System.assertEquals('SalesforceCategory0', articlesWrapped.get(2).categories.get(0).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory1', articlesWrapped.get(2).categories.get(1).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory2', articlesWrapped.get(2).categories.get(2).Name, 'result should contain category in article');
    }

    @isTest
    static void testFilterDataByTags() {	

        List<brBlog_article__c> articles = [SELECT Id, Name FROM brBlog_article__c LIMIT 150];
        List<brBlog_Tag__c> tags = brBlogTestUtils.testCreateTags();
        brBlogTestUtils.testCreateTagsAssignment();

        brBlog_Tag__c tag = new brBlog_Tag__c(Name ='SalesforceTag3');
        insert tag;

        brBlog_Tag_Assignment__c tagAssignment = new brBlog_Tag_Assignment__c
        (Blog_Article__c = articles.get(0).Id, Blog_Tag__c = tag.Id);

        insert tagAssignment;

        Map<String, String> filterDataByTags = new Map<String, String>();
        filterDataByTags.put('tag',tag.Name);

        Test.startTest();
        List<brBlogArticleWrapper> articlesWrapped = brBlogArticlesListCtrl.getArticles(filterDataByTags, 1, 3);
        Test.stopTest();

        System.assertEquals('What is Salesforce', articlesWrapped.get(0).item.Name, 'result should contain name in article');
        System.assertEquals('Salesforce  is an American cloud computing company', articlesWrapped.get(0).item.Short_Body__c,
                             'result should contain body in article');

        System.assertEquals('SalesforceTag0', articlesWrapped.get(0).tags.get(0).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag1', articlesWrapped.get(0).tags.get(1).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag2', articlesWrapped.get(0).tags.get(2).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag3', articlesWrapped.get(0).tags.get(3).Name, 'result should contain tag in article');

        System.assertEquals('SalesforceCategory0', articlesWrapped.get(0).categories.get(0).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory1', articlesWrapped.get(0).categories.get(1).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory2', articlesWrapped.get(0).categories.get(2).Name, 'result should contain category in article');
    }

    @isTest
    static void testFilterDataByCategories() {

        List<brBlog_article__c> articles = [SELECT Id, Name FROM brBlog_article__c LIMIT 150];
        List<brBlog_Category__c> categories = [SELECT Id, Name FROM brBlog_Category__c LIMIT 150];
        brBlogTestUtils.testCreateTags();
        brBlogTestUtils.testCreateTagsAssignment();

        brBlog_Category__c category = new brBlog_Category__c(Name ='SalesforceCategory3');
        insert category;

        brCategory_assignment__c categoryAssignment = new brCategory_assignment__c
        (Blog_Article__c = articles.get(0).Id, Blog_Category__c = category.Id);

        insert categoryAssignment;

        Map<String, String> filterDataByCategories = new Map<String, String>();
        filterDataByCategories.put('category',category.Name);

        Test.startTest();
        List<brBlogArticleWrapper> articlesWrapped = brBlogArticlesListCtrl.getArticles(filterDataByCategories, 1, 3);
        Test.stopTest();

        System.assertEquals('What is Salesforce', articlesWrapped.get(0).item.Name, 'result should contain name in article');
        System.assertEquals('Salesforce  is an American cloud computing company', articlesWrapped.get(0).item.Short_Body__c,
                             'result should contain body in article');

        System.assertEquals('SalesforceTag0', articlesWrapped.get(0).tags.get(0).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag1', articlesWrapped.get(0).tags.get(1).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag2', articlesWrapped.get(0).tags.get(2).Name, 'result should contain tag in article');

        System.assertEquals('SalesforceCategory0', articlesWrapped.get(0).categories.get(0).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory1', articlesWrapped.get(0).categories.get(1).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory2', articlesWrapped.get(0).categories.get(2).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory3', articlesWrapped.get(0).categories.get(3).Name, 'result should contain category in article');
    }

    @isTest
    static void testCountFilterData() {

        List<brBlog_article__c> articles = [SELECT Id, Name FROM brBlog_article__c LIMIT 150];
    
        brBlog_Category__c category = new brBlog_Category__c(Name ='SalesforceCategory3');
        insert category;

        brCategory_assignment__c categoryAssignment = new brCategory_assignment__c
        (Blog_Article__c = articles.get(0).Id, Blog_Category__c = category.Id);

        insert categoryAssignment;

        Map<String, String> filterDataByCategories = new Map<String, String>();
        filterDataByCategories.put('category',category.Name);

        Test.startTest();
        Integer articlesCount = brBlogArticlesListCtrl.getArticlesCount(filterDataByCategories);
        Test.stopTest(); 

        System.assertEquals(1, articlesCount, 'result should contain one article');
    }
}