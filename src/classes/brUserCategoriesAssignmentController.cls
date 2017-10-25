public with sharing class brUserCategoriesAssignmentController {

    @AuraEnabled
    public static List<String> getCategoriesOptions(){
        List<String> categoriesOptions = new List<String>();
        Schema.DescribeFieldResult categoriesFieldDescribe = Schema.Idea.Categories.getDescribe();
        List<Schema.PicklistEntry> picklistValues = categoriesFieldDescribe.getPicklistValues();

        for (Schema.PicklistEntry picklistItem : picklistValues) {
            categoriesOptions.add(picklistItem.getValue());
        }

        return categoriesOptions;
    }

    @AuraEnabled
    public static List<brIdeasCategoriesAssignment__c> getAssignments(){
        return [SELECT User__r.Username, Categories__c
                FROM brIdeasCategoriesAssignment__c
                ORDER BY CreatedDate ASC];
    }

    @AuraEnabled
    public static Map<String, String> saveAssignment(String username, String categories){
        Map<String, String> resVal = new Map<String, String>();
        User usr;

        try {
            usr = [SELECT Id FROM User WHERE Username = :username];
        } catch (Exception ex) {
            resVal.put('error', '1');
            resVal.put('errorMsg', 'User does not exist');

            return resVal;
        }

        brIdeasCategoriesAssignment__c assi;

        try {
            assi = [SELECT Categories__c FROM brIdeasCategoriesAssignment__c
                    WHERE User__c = :usr.Id];
            assi.Categories__c = categories;
        } catch (Exception ex) {
            assi = new brIdeasCategoriesAssignment__c(
                    User__c = usr.Id,
                    Categories__c = categories
                );
        }

        upsert assi;

        return resVal;
    }

    @AuraEnabled
    public static void deleteAssignment(String aId){
        brIdeasCategoriesAssignment__c assignment = [SELECT Id FROM brIdeasCategoriesAssignment__c
                                                                WHERE Id = :aId];

        delete assignment;
    }
}