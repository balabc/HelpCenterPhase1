@isTest
private class brTopTrendingCtrlTest {

    static testMethod void TopTrendingTest() {
        CollaborationGroup cg = new CollaborationGroup();
        cg.Name = 'Test11';
        cg.CollaborationType = 'Public';
        insert cg;

        CollaborationGroup cg2 = new CollaborationGroup();
        cg2.Name = 'Test2';
        cg2.CollaborationType = 'Public';
        insert cg2;

        CollaborationGroup cg3 = new CollaborationGroup();
        cg3.Name = 'Test3';
        cg3.CollaborationType = 'Public';
        insert cg3;

        CollaborationGroup cg4 = new CollaborationGroup();
        cg4.Name = 'Test4';
        cg4.CollaborationType = 'Public';
        insert cg4;
/*
        Topic top = new Topic();
        top.Name = 'Test';
        insert top;*/

        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;

        FeedItem fi = new FeedItem();
        fi.Title = 'Test';
        fi.Body = 'Test';
        fi.ParentId = UserInfo.getUserId();
        fi.Type = 'QuestionPost';
        insert fi;

        FeedItem fi2 = new FeedItem();
        fi2.Body = '<b>Test2</b>';
        fi2.ParentId = cg.Id;
        fi2.Type = 'TextPost';
        fi2.Visibility = 'AllUsers';
        insert fi2;

        brBlog_article__c ba = new brBlog_article__c();
        ba.Published_Date__c = DateTime.now();
        ba.Published__c = true;
        ba.Name = 'Test';
        insert ba;


        Test.startTest();
        String groupListView = brTopTrendingCtrl.getChatterGroupListId();
        System.assertEquals(true, groupListView.length() > 0);
        System.assertEquals(1, brTopTrendingCtrl.getChatterGroupByStringId(cg.id).size());
        System.assertEquals(2, brTopTrendingCtrl.getChatterGroupByStringId(cg.id + ',' + cg2.id).size());
        System.assertEquals(3, brTopTrendingCtrl.getChatterGroupByStringId(cg.id + ',' + cg2.id + ',' + cg3.id).size());
        System.assertEquals(4, brTopTrendingCtrl.getChatterGroupByStringId(cg.id + ',' + cg2.id + ',' + cg3.id + ',' + cg4.id).size());
        System.assertEquals(1, brTopTrendingCtrl.getQuestions().size());
        System.assertEquals(1, brTopTrendingCtrl.getBlogArticles().size());

        brTopTrendingCtrl.getGroupPosts(cg.Id);

    }

}