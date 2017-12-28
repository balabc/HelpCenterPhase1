/**
 * This class is controller for brVideosList aura component
 */
public with sharing class brVideosListCtrl {
    /**
     * Returns list knowledge articles for videos page
     *
     * @return knowledge articles ordered by Sort_Order__c field ascending.
     * If Sort_Order__c field is empty then the object will be added to the end of the list.
     */

    @AuraEnabled
    public static List<University__kav> getVideoArticles() {
        brSecurityService.performAccessCheck('read', 'University__kav', new List<String>{'Title','Short_Title__c','Short_Description__c',
            'Video_Duration__c','Thumbnail_Image_URL__c','Sort_Order__c'});

        List<University__kav> uKavs = new List<University__kav>();

        try {
            uKavs = [SELECT Id, Title, Short_Title__c, Short_Description__c, Video_Duration__c, Thumbnail_Image_URL__c
            FROM University__kav ORDER BY Sort_Order__c ASC NULLS LAST];
        } catch (QueryException ex) {
            System.debug('brVideosListCtrl::getVideoArticles: ' + ex.getMessage());
        }
        return uKavs;
    }
}