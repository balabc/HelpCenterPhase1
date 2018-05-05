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
        brLiveMetricsCtrl.getIdeaCount();
        brIdeaService.getIdeaCount();
        brIdeaServiceSelector.getIdeaList(null);
        brIdeaServiceSelector.getZoneList();
        brLiveMetricsCtrl.getFeedItemCount();
        List<NetworkMember> userMembers = [SELECT MemberId, Member.Name, ReputationPoints, NetworkId FROM NetworkMember];
        if (userMembers.size() > 0) {
            brLiveMetricsCtrl.getUserCount();
        }
        Test.stopTest();
    }

    static testMethod void testGetCurrentUserName() {
        Test.startTest();
        String userName = brLiveMetricsCtrl.getCurrentUserName();
        Test.stopTest();

        System.assertEquals(' ' + UserInfo.getFirstName(), userName, 'result without current user');
    }
}