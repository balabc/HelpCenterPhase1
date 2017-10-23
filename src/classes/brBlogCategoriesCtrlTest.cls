@isTest
private class brBlogCategoriesCtrlTest {

    @isTest
	static void testGetCategories() {

        brBlogTestUtils.testCreateCategories();
        brBlogTestUtils.testCreateArticles();
        brBlogTestUtils.testCreateCategoriesAssignment();

        Test.startTest();
        List<AggregateResult> blogCategories = brBlogCategoriesCtrl.getCategories();
        Test.stopTest();

        System.assertEquals('SalesforceCategory0', blogCategories.get(0).get('categoryName'), 'result should contain categories in ascending order');
        System.assertEquals('SalesforceCategory1', blogCategories.get(1).get('categoryName'), 'result should contain categories in ascending order');
        System.assertEquals('SalesforceCategory2', blogCategories.get(2).get('categoryName'), 'result should contain categories in ascending order');
	}
}