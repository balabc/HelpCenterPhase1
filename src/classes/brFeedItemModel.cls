public with sharing class brFeedItemModel {

    /**
     * feed id
     */
    @AuraEnabled
    public String id { get; set; }

    /**
     * feed name
     */
    @AuraEnabled
    public String name { get; set; }

}