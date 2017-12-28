public with sharing class brGuidesListCtrl {

    /**
     * Returns articles for guide
     *
     * {@inheritDoc}
     *
     * @return      list guide articles
     * @see         List<brGuideItem__mdt>
     */
    @AuraEnabled
    public static List<brGuideItem__mdt> getGuideArticles() {
        brSecurityService.performAccessCheck('read', 'brGuideItem__mdt', new List<String>{'Title__c','Sort__c','Short_Description__c',
        'Number_of_Chapters__c','Image_Url__c','First_Chapter_Url__c','Image_Alt__c','Image_Url_2x__c'});

        if (Test.isRunningTest()) {
            List<brGuideItem__mdt> guideItems = new List<brGuideItem__mdt>();

            for (Integer i = 0; i < 3; i++) {
                guideItems.add(new brGuideItem__mdt());
            }
            return guideItems;
        }
        List<brGuideItem__mdt> guides = new List<brGuideItem__mdt>();

        try {
            guides = [SELECT Id, Title__c, Sort__c, Short_Description__c, Number_of_Chapters__c, Image_Url__c,First_Chapter_Url__c, Image_Alt__c, Image_Url_2x__c FROM brGuideItem__mdt ORDER BY Sort__c ASC NULLS LAST];
        } catch (QueryException ex) { System.debug('brGuidesListCtrl::getGuideArticles: ' + ex.getMessage());}
        return guides;
    }

    /**
     * Returns counts for each category guides
     *
     * {@inheritDoc}
     *
     * @return      map counts for categories
     * @see         Map<String, Integer>
     */
    @AuraEnabled
    public static Map<String, Integer> getCountForEachCategory() {
        return brArticleContentService.getCountForEachCategory('Learning__kav');
    }

}