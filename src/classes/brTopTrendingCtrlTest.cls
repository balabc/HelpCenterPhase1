@isTest
private class brTopTrendingCtrlTest {
    static testMethod void TopTrendingTest() {
    	CollaborationGroup cg = new CollaborationGroup();
    	cg.Name = 'Test1';
    	cg.CollaborationType = 'Public';
    	insert cg;	     
    	
    	CollaborationGroup cg2 = new CollaborationGroup();
    	cg2.Name = 'Test2';
    	cg2.CollaborationType = 'Public';
    	insert cg2;	     	       
    	
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
    	
    	brBlog_article__c ba = new brBlog_article__c();
    	ba.Published_Date__c = DateTime.now();
    	ba.Published__c = true;
    	ba.Name = 'Test';
    	insert ba;
    	
    	
    	Test.startTest();
    		String groupListView = brTopTrendingCtrl.getChatterGroupListId();
    		System.assertEquals(true,groupListView.length() > 0);
    		System.assertEquals(1,brTopTrendingCtrl.getChatterGroupByStringId(cg.id).size());
    		System.assertEquals(2,brTopTrendingCtrl.getChatterGroupByStringId(cg.id + ',' + cg2.id).size());
    		System.assertEquals(1,brTopTrendingCtrl.getQuestions().size());
    		System.assertEquals(1,brTopTrendingCtrl.getBlogArticles().size());
    	Test.stopTest();
    }
}