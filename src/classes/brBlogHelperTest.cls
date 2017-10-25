@isTest
private class brBlogHelperTest {

    @testSetup 
    static void insertArticles() {
        List<brBlog_article__c> articles = brBlogTestUtils.testCreateArticles();

        System.assertEquals('What is Salesforce', articles[0].Name, 'get first article name value');
    }

    @isTest
    static void testGetArticleCategories() {

        brBlogTestUtils.testCreateCategories();
        brBlogTestUtils.testCreateCategoriesAssignment();
        List<brCategory_assignment__c> categoryAssignments = [SELECT Id, Name,
        Blog_Category__r.Id, Blog_Category__r.Name FROM brCategory_assignment__c LIMIT 150];

        Test.startTest();
        List<brBlog_Category__c> categories = brBlogHelper.getArticleCategories(categoryAssignments);
        Test.stopTest();

        System.assertEquals('SalesforceCategory0', categories.get(0).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory1', categories.get(1).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory2', categories.get(2).Name, 'result should contain category in article');
    }

    @isTest
    static void testGetArticleTags() {

        brBlogTestUtils.testCreateTags();
        brBlogTestUtils.testCreateTagsAssignment();
        List<brBlog_Tag_Assignment__c> tagsAssignments = [SELECT Id, Name,
        Blog_Tag__r.Id, Blog_Tag__r.Name FROM brBlog_Tag_Assignment__c LIMIT 150];

        Test.startTest();
        List<brBlog_Tag__c> tags = brBlogHelper.getArticleTags(tagsAssignments);
        Test.stopTest();

        System.assertEquals('SalesforceTag0', tags.get(0).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag1', tags.get(1).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag2', tags.get(2).Name, 'result should contain tag in article');
    }

    @isTest
    static void testGetCommentsNumber() {

        List<brBlog_article__c> articles = [SELECT Id, Name FROM brBlog_article__c LIMIT 150];
        FeedItem post = new FeedItem();
        post.ParentId = articles.get(0).Id;
        post.Title = 'Salesforce';
        post.Body = 'Salesforce is one of the best CRM';

        insert post;

        List<FeedComment> comments = new List<FeedComment>();

        for (Integer i = 0; i < 4; i++) {
            comments.add(new FeedComment(CommentBody = 'good article!', FeedItemId = post.Id));
        }

        insert comments;

        Test.startTest();
        Integer commentsNumber = brBlogHelper.getCommentsNumber(articles.get(0).Id);
        Test.stopTest();

        System.assertEquals(5, commentsNumber, 'result should contain comments number in article');
    }

    @isTest
    static void testCompileWhereStatementForTags() {

        List<brBlog_Tag__c> tags = brBlogTestUtils.testCreateTags();
        brBlogTestUtils.testCreateTagsAssignment();

        Map<String, String> filterDataByTag = new Map<String, String>();
        filterDataByTag.put('tag', tags.get(0).Name);

        Test.startTest();
        String whereString = brBlogHelper.compileWhereStatement(filterDataByTag);
        Test.stopTest();

        List<brBlog_Article__c> articles = [SELECT Id FROM brBlog_Article__c LIMIT 150];

        List<String> articlesId = new List<String>();

        for (brBlog_Article__c article : articles) {
            articlesId.add(article.Id);
        }

        List<String> result = new List<String>();
        result.add('Id IN (\'' + String.join(articlesId, '\',\'') + '\')');

        String whereResult = String.join(result, ' AND ');

        System.assertEquals(whereResult, whereString, 'result should contain all articles id by current tag');
    }

    @isTest
    static void testCompileWhereStatementForCategories() {

        List<brBlog_Category__c> categories = brBlogTestUtils.testCreateCategories();
        brBlogTestUtils.testCreateCategoriesAssignment();

        Map<String, String> filterDataByCategory = new Map<String, String>();
        filterDataByCategory.put('category', categories.get(0).Name);

        Test.startTest();
        String whereString = brBlogHelper.compileWhereStatement(filterDataByCategory);
        Test.stopTest();

        List<brBlog_Article__c> articles = [SELECT Id FROM brBlog_Article__c LIMIT 150];

        List<String> articlesId = new List<String>();

        for (brBlog_Article__c article : articles) {
            articlesId.add(article.Id);
        }

        List<String> result = new List<String>();
        result.add('Id IN (\'' + String.join(articlesId, '\',\'') + '\')');

        String whereResult = String.join(result, ' AND ');

        System.assertEquals(whereResult, whereString, 'result should contain all articles id by current category');
    }

    @isTest
    static void testGetProfilePhotoUrl() {
        brBlogTestUtils.testCreateUser();

        List<User> users = [SELECT Id, SmallPhotoUrl FROM User WHERE username ='standardusekjnkjnr@testorg.com'];

        Set<Id> userIds = new Set<Id>();

        for (User user : users) {
            userIds.add(user.Id);
        }

        Test.startTest();
        Map<Id,String> photoUrlByUser = brBlogHelper.getProfilePhotoUrl(userIds);
        Test.stopTest();

        System.assertEquals(1, photoUrlByUser.size());
        System.assertEquals(users[0].SmallPhotoUrl, photoUrlByUser.get(users[0].Id));

    }
}