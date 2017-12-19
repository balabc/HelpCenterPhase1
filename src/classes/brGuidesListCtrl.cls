public with sharing class brGuidesListCtrl {

    @AuraEnabled
    public static List<brGuideItem__mdt> getGuideArticles() {
        if (Test.isRunningTest()) {
            List<brGuideItem__mdt> guideItems = new List<brGuideItem__mdt>();

            for (Integer i = 0; i < 3; i++) {
                guideItems.add(new brGuideItem__mdt());
            }
            return guideItems;
        }
        return [SELECT Id, Title__c, Sort__c, Short_Description__c, Number_of_Chapters__c, Image_Url__c,
                First_Chapter_Url__c, Image_Alt__c, Image_Url_2x__c
                FROM brGuideItem__mdt ORDER BY Sort__c ASC NULLS LAST];
    }

    @AuraEnabled
    public static Map<String, Integer> getCountForEachCategory() {
        return brArticleContentService.getCountForEachCategory('Learning__DataCategorySelection');
    }

}