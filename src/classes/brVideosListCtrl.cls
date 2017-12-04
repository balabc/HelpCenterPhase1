public with sharing class brVideosListCtrl {

    @AuraEnabled
    public static List<University__kav> getVideoArticles() {
        return [SELECT Title, Short_Title__c, Short_Description__c, Video_Duration__c, Thumbnail_Image_URL__c
                FROM University__kav ORDER BY Sort_Order__c ASC NULLS LAST];
    }
}