public with sharing class BrEventCommunityLinkCtrl {
        public String eventId {get; set;}

    public BrEventCommunityLinkCtrl() {}

    public String getCommunityLink() {
        //BrEvents_Settings__c communityRow = [SELECT Value__c FROM BrEvents_Settings__c WHERE Name = 'community'];
//        String instanceUrl = Network.getLoginUrl('0DBi0000000XZOEGA4').replace('login', '');
//
//        return ' ' + instanceUrl + 'events#' + eventId;

        return '';
    }
}