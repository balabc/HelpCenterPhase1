@isTest
private class brUserCategoriesAssignmentControllerTest {

    @testSetup
    private static void setup(){
        Test.startTest();

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        List<User> users = new List<User>();

        users.add(new User(
                Username = 'unittest1@UserCategoriesAssignmentControllerTest.com',
                Email = 'unittest1@UserCategoriesAssignmentControllerTest.com',
                Alias = 'test1', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id, TimeZoneSidKey='America/Los_Angeles'
        ));
        users.add(new User(
                Username = 'unittest2@UserCategoriesAssignmentControllerTest.com',
                Email = 'unittest2@UserCategoriesAssignmentControllerTest.com',
                Alias = 'test2', EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id, TimeZoneSidKey='America/Los_Angeles'
        ));

        insert users;

        brIdeasCategoriesAssignment__c assignment = new brIdeasCategoriesAssignment__c(
                User__c = users[0].Id,
                Categories__c = 'Category 1'
        );

        insert assignment;

        Test.stopTest();

        Integer recordsNumber = [SELECT COUNT() FROM brIdeasCategoriesAssignment__c];

        System.assertEquals(1, recordsNumber);
    }

    @isTest
    private static void testGetCategoriesOptions(){
        Test.startTest();
        List<String> options = brUserCategoriesAssignmentController.getCategoriesOptions();
        Test.stopTest();

        System.assert(true);
    }

    @isTest
    private static void testGetAssignments(){
        Test.startTest();
        List<brIdeasCategoriesAssignment__c> records = brUserCategoriesAssignmentController.getAssignments();
        Test.stopTest();

        System.assertEquals(1, records.size());
    }

    @isTest
    private static void testSaveAssignment(){
        Test.startTest();

        brIdeasCategoriesAssignment__c initialRecord = [SELECT User__r.Username, Categories__c
        FROM brIdeasCategoriesAssignment__c LIMIT 1];

        Map<String, String> failInsertRes = brUserCategoriesAssignmentController.saveAssignment('notexisting@user.com', 'Somecat');

        Integer numberAfterFailInsert = [SELECT COUNT() FROM brIdeasCategoriesAssignment__c];

        Map<String, String> updateRes = brUserCategoriesAssignmentController.saveAssignment(initialRecord.User__r.Username,
                'Updated category');

        Integer numberAfterUpdate = [SELECT COUNT() FROM brIdeasCategoriesAssignment__c];
        brIdeasCategoriesAssignment__c updatedRecord = [SELECT Categories__c
        FROM brIdeasCategoriesAssignment__c
        LIMIT 1];

        Map<String, String> successInsertRes = brUserCategoriesAssignmentController.saveAssignment('unittest2@UserCategoriesAssignmentControllerTest.com', 'Inserted category');

        Integer numberSuccessInsert = [SELECT COUNT() FROM brIdeasCategoriesAssignment__c];

        Test.stopTest();

        System.assertEquals(1, numberAfterFailInsert);
        System.assertEquals('1', failInsertRes.get('error'));
        System.assertEquals(1, numberAfterUpdate);
        System.assertEquals(NULL,  updateRes.get('error'));
        System.assertEquals('Updated category', updatedRecord.Categories__c);
        System.assertEquals(2, numberSuccessInsert);
        System.assertEquals(NULL,  successInsertRes.get('error'));
    }

    @isTest
    private static void testDeleteAssignment(){
        Test.startTest();

        List<brIdeasCategoriesAssignment__c> initialRecords = [SELECT Id FROM brIdeasCategoriesAssignment__c];

        brUserCategoriesAssignmentController.deleteAssignment(initialRecords[0].Id);

        Integer numberAfterDelete = [SELECT COUNT() FROM brIdeasCategoriesAssignment__c];

        Test.stopTest();

        System.assertEquals(1, initialRecords.size());
        System.assertEquals(0, numberAfterDelete);
    }
}