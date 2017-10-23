@isTest
private class brBlogTagsTriggerTest {

    @testSetup 
    static void insertTags() {

        List<brBlog_Tag__c> tags = new List<brBlog_Tag__c>();

        for (Integer i = 0; i < 2; i++) {
            tags.add(new brBlog_Tag__c(Name = ' .T*e$><s^[],/|t=+!?{}() ' + i,
            Friendly_URL__c = null));
        }

        insert tags;

       System.assertEquals(2, tags.size(), 'contain two tags');
    }

    @isTest
    static void testFriendlyUrlOnInsertWithEmptyFriendlyUrlAndWithoutNumbersForName() {

        List<brBlog_Tag__c> tags = new List<brBlog_Tag__c>();

        for (Integer i = 0; i < 3; i++) {
            tags.add(new brBlog_Tag__c(Name = ' .T*---e$><s^[],/|t=+!?{}() ',
            Friendly_URL__c = null));
        } 

        Test.startTest();
        insert tags;
        Test.stopTest();

        List<brBlog_Tag__c> newTags = [SELECT Friendly_URL__c FROM
        brBlog_Tag__c LIMIT 150];

        System.assertEquals('t-est', newTags.get(2).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
        System.assertEquals('t-est1', newTags.get(3).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
        System.assertEquals('t-est2', newTags.get(4).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
    }

    @isTest
    static void testFriendlyUrlOnInsertWithEmptyFriendlyUrlAndWithNumbersForName() {

        List<brBlog_Tag__c> tags = new List<brBlog_Tag__c>();

        for (Integer i = 0; i < 4; i++) {
            tags.add(new brBlog_Tag__c(Name = ' .T*---e$><s^[],/|t=+!?{}() ' + 1,
            Friendly_URL__c = null));
        } 

        Test.startTest();
        insert tags;
        Test.stopTest();

        List<brBlog_Tag__c> newTags = [SELECT Friendly_URL__c FROM
        brBlog_Tag__c LIMIT 150];

        System.assertEquals('t-est-1', newTags.get(2).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
        System.assertEquals('t-est-11', newTags.get(3).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
        System.assertEquals('t-est-12', newTags.get(4).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
        System.assertEquals('t-est-13', newTags.get(5).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on insert');
    }

    @isTest
    static void testFriendlyUrlOnInsertWithNotEmptyFriendlyUrl() {

        List<brBlog_Tag__c> tags = new List<brBlog_Tag__c>();

        tags.add(new brBlog_Tag__c(
            Name = 'T-#e%s&:;t_~`-1@№', Friendly_URL__c = null));

        tags.add(new brBlog_Tag__c(
            Name = 'Test3', Friendly_URL__c = 't-est-1'));

        Test.startTest();
        insert tags;
        Test.stopTest();

        List<brBlog_Tag__c> newTags = [SELECT Friendly_URL__c FROM brBlog_Tag__c LIMIT 150];

        System.assertEquals('t-est-1', newTags.get(2).Friendly_URL__c, 'result should contain unique value and without symbols on insert');

        System.assertEquals('t-est-11', newTags.get(3).Friendly_URL__c, 'result should contain unique value and without symbols on insert');
    }

    @isTest
    static void testOnUpdateWithoutChangeFriendlyUrl() {

        List<brBlog_Tag__c> newTags = new List<brBlog_Tag__c>();

        newTags = [SELECT Friendly_URL__c FROM brBlog_Tag__c LIMIT 150];

        Test.startTest();
        update newTags;
        Test.stopTest();

        System.assertEquals('test-0', newTags.get(0).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on update');
        System.assertEquals('test-1', newTags.get(1).Friendly_URL__c, 'result should contain not empty and without symbols friendly url on update');
    } 

    @isTest
    static void testOnUpdateWithChangeFriendlyUrl() {

        List<brBlog_Tag__c> newTags = new List<brBlog_Tag__c>();

        newTags = [SELECT Friendly_URL__c FROM brBlog_Tag__c LIMIT 150];
        List<brBlog_Tag__c> updateTags =
        new List<brBlog_Tag__c>();

        for (brBlog_Tag__c tag : newTags) {
            tag.Friendly_URL__c = 'T!@e_s+?t 1';
            updateTags.add(tag);
        }

        Test.startTest();
        update updateTags;
        Test.stopTest();

        updateTags = [SELECT Friendly_URL__c FROM brBlog_Tag__c LIMIT 150];

        System.assertEquals('test-1', updateTags.get(0).Friendly_URL__c, 'result should contain unique value and without symbols on update');
        System.assertEquals('test-11', updateTags.get(1).Friendly_URL__c, 'result should contain unique value and without symbols on update');
    }
}