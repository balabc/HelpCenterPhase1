public with sharing class brBlogCategoriesCtrl {

    @AuraEnabled
    public static List<AggregateResult> getCategories() {

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_article__c', new List<String>{'Published_Date__c', 'Draft__c'})
                || !brBlogHelper.performAccessCheck('read', 'brBlog_Category__c', new List<String>{'Friendly_URL__c'})
                || !brBlogHelper.performAccessCheck('read', 'brCategory_Assignment__c', new List<String>{'Blog_Category__c'})){
            return null;
        }

        String currentTimeGMT = DateTime.now().formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');

        String query = 'SELECT Blog_Category__r.Name categoryName, MIN(Blog_Category__r.Friendly_URL__c) urlName,' +
                ' COUNT(Blog_Category__c) categoryCount' +
                ' FROM brCategory_assignment__c' +
                ' WHERE Blog_Article__r.Draft__c = false' +
                ' AND Blog_Article__r.Published_Date__c < ' + currentTimeGMT +
                ' GROUP BY Blog_Category__r.Name';

        return Database.query(query);
    }
}