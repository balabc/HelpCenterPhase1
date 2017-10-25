@isTest
private class brBlogCategoryTriggerTest {

    @testSetup 
    static void insertCategories() {

        List<brBlog_Category__c> categories = new List<brBlog_Category__c>();

        for (Integer i = 0; i < 2; i++) {
            categories.add(new brBlog_Category__c(Name = ' .T*e$><s^[],/|t=+!?{}() ' + i,
            Friendly_URL__c = null));
        }   
            
        insert categories;

        System.assertEquals(2, categories.size(), 'contain two categories ');
    }

    @isTest
    static void testFriendlyUrlOnInsertWithEmptyFriendlyUrlAndWithoutNumbersForName() {

        List<brBlog_Category__c> categories = new List<brBlog_Category__c>();

        for (Integer i = 0; i < 3; i++) {
            categories.add(new brBlog_Category__c(Name = ' .T*---e$><s^[],/|t=+!?{}() ',
            Friendly_URL__c = null));
        } 

        Test.startTest();
        insert categories;
        Test.stopTest();

        List<brBlog_Category__c> newCategories = [SELECT Friendly_URL__c FROM
        brBlog_Category__c LIMIT 150];

        System.assertEquals('t-est', newCategories.get(2).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
        System.assertEquals('t-est1', newCategories.get(3).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
        System.assertEquals('t-est2', newCategories.get(4).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
    }

    @isTest
    static void testFriendlyUrlOnInsertWithEmptyFriendlyUrlAndWithNumbersForName() {

        List<brBlog_Category__c> categories = new List<brBlog_Category__c>();

        for (Integer i = 0; i < 4; i++) {
            categories.add(new brBlog_Category__c(Name = ' .T*---e$><s^[],/|t=+!?{}() ' + 1,
            Friendly_URL__c = null));
        } 

        Test.startTest();
        insert categories;
        Test.stopTest();

        List<brBlog_Category__c> newCategories = [SELECT Friendly_URL__c FROM
        brBlog_Category__c LIMIT 150];

        System.assertEquals('t-est-1', newCategories.get(2).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
        System.assertEquals('t-est-11', newCategories.get(3).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
        System.assertEquals('t-est-12', newCategories.get(4).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
        System.assertEquals('t-est-13', newCategories.get(5).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
    }

    @isTest
    static void testFriendlyUrlOnInsertWithNotEmptyFriendlyUrl() {

        List<brBlog_Category__c> categories = new List<brBlog_Category__c>();

        categories.add(new brBlog_Category__c(
            Name = 'T-#e%s&:;t_~`-1@№', Friendly_URL__c = null));

        categories.add(new brBlog_Category__c(
            Name = 'Test3', Friendly_URL__c = 't-est-1'));

        Test.startTest();
        insert categories;
        Test.stopTest();

        List<brBlog_Category__c> newCategories = [SELECT Friendly_URL__c FROM brBlog_Category__c LIMIT 150];

        System.assertEquals('t-est-1', newCategories.get(2).Friendly_URL__c, 'result should contain unique value and without symbols on insert');

        System.assertEquals('t-est-11', newCategories.get(3).Friendly_URL__c, 'result should contain unique value and without symbols on insert');
    }

    @isTest
    static void testOnUpdateWithoutChangeFriendlyUrl() {

        List<brBlog_Category__c> newCategories = new List<brBlog_Category__c>();

        newCategories = [SELECT Friendly_URL__c FROM brBlog_Category__c LIMIT 150];

        Test.startTest();
        update newCategories;
        Test.stopTest();

        System.assertEquals('test-0', newCategories.get(0).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on update');
        System.assertEquals('test-1', newCategories.get(1).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on update');
    } 

    @isTest
    static void testOnUpdateWithChangeFriendlyUrl() {

        List<brBlog_Category__c> newCategories = new List<brBlog_Category__c>();

        newCategories = [SELECT Friendly_URL__c FROM brBlog_Category__c LIMIT 150];
        List<brBlog_Category__c> updateCategories =
        new List<brBlog_Category__c>();

        for (brBlog_Category__c category : newCategories) {
            category.Friendly_URL__c = 'T!@e_s+?t 1';
            updateCategories.add(category);
        }

        Test.startTest();
        update updateCategories;
        Test.stopTest();

        updateCategories = [SELECT Friendly_URL__c FROM brBlog_Category__c LIMIT 150];

        System.assertEquals('test-1', updateCategories.get(0).Friendly_URL__c, 'result should contain unique value and without symbols on update');
        System.assertEquals('test-11', updateCategories.get(1).Friendly_URL__c, 'result should contain unique value and without symbols on update');
    }
}