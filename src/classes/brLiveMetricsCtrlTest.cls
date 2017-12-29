@isTest
private class brLiveMetricsCtrlTest {

    static testMethod void brLiveMetricsCtrlTest() {

        Topic top = new Topic();
        top.Name = 'Test';
        insert top;

        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;

        FeedItem fi = new FeedItem();
        fi.Title = 'Test';
        fi.Body = 'Test';
        fi.ParentId = acc.id;
        insert fi;

        TopicAssignment ta = new TopicAssignment();
        ta.TopicId = top.id;
        ta.EntityId = fi.id;
        insert ta;

        Test.startTest();
        brLiveMetricsCtrl.getCommunityId();
        brLiveMetricsCtrl.getIdeaCount();
        brIdeaService.getIdeaCount(null);
        brIdeaServiceSelector.getIdeaList(null);
        brIdeaServiceSelector.getZoneList(null);
        brLiveMetricsCtrl.getFeedItemCount();
        List<NetworkMember> userMembers = [SELECT MemberId, Member.Name, ReputationPoints, NetworkId FROM NetworkMember];
        if (userMembers.size() > 0) {
            brLiveMetricsCtrl.getUserCount();
        }
        Test.stopTest();
    }

}