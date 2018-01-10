@isTest
private class brLiveMetricsCtrlTest {

    static testMethod void brLiveMetricsCtrlTest() {

        FeedItem fi = new FeedItem();
        fi.Title = 'Test';
        fi.Body = 'Test';
        fi.ParentId = UserInfo.getUserId();
        fi.Type = 'QuestionPost';
        fi.Visibility = 'AllUsers';
        insert fi;

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