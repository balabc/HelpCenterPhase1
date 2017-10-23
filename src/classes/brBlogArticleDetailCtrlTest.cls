@isTest
private class brBlogArticleDetailCtrlTest {

    @isTest
    static void testGetArticle() {

        List<brBlog_article__c> articles = brBlogTestUtils.testCreateArticles();
        brBlogTestUtils.testCreateTags();
        brBlogTestUtils.testCreateCategories();
        brBlogTestUtils.testCreateTagsAssignment();
        brBlogTestUtils.testCreateCategoriesAssignment();

        Test.startTest();
        brBlogArticleWrapper wrapArticle =  brBlogArticleDetailCtrl.getArticle(articles.get(0).Id);
        Test.stopTest();
        
        System.assertEquals('What is Salesforce', wrapArticle.item.Name, 'result should contain name in article');

        System.assertEquals('SalesforceTag0', wrapArticle.tags.get(0).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag1', wrapArticle.tags.get(1).Name, 'result should contain tag in article');
        System.assertEquals('SalesforceTag2', wrapArticle.tags.get(2).Name, 'result should contain tag in article');

        System.assertEquals('SalesforceCategory0', wrapArticle.categories.get(0).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory1', wrapArticle.categories.get(1).Name, 'result should contain category in article');
        System.assertEquals('SalesforceCategory2', wrapArticle.categories.get(2).Name, 'result should contain category in article');

        wrapArticle = brBlogArticleDetailCtrl.getArticle(null);
        System.assertEquals(null, wrapArticle.tags, 'result should have null value');
        System.assertEquals(null, wrapArticle.categories, 'result should have null value');
        System.assertEquals(null, wrapArticle.item, 'result should have null value');
    }
}