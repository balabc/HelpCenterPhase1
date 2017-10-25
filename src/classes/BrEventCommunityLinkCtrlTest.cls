@IsTest
private class BrEventCommunityLinkCtrlTest {
    static testMethod void testGetCommunityLink() {
        DateTime startDate = DateTime.now();
        BR_Event__c event = new BR_Event__c(Name = 'testEvent', Start_Date__c = startDate, Send_reminders__c = true);

        insert event;

        String communityId = [SELECT Id FROM Network LIMIT 1].Id;

        insert new BrEvents_Settings__c(Name='community', Label__c = 'Community', Value__c = communityId);

        BrEventCommunityLinkCtrl ctrl = new BrEventCommunityLinkCtrl();
        ctrl.eventId = event.Id;
        System.assertNotEquals(null, ctrl.getCommunityLink(), 'Community link is empty');
    }
}