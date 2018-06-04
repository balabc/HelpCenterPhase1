@isTest
private class brLghtIdeasControllerTest {

	@testSetup
	static void setup() {
		Test.startTest();

		User user = brTestDataFactory.createTestStandardProfileUser();

		System.assertEquals('sysUserBaker@test.com', user.UserName, 'wrong username');

		System.runAs(user) {
			List<Idea> ideasList;
			Idea testIdea_1;
			String cId;
			Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

			brLghtIdeasSettings__c communitySettings = new brLghtIdeasSettings__c(Name = 'community', Value__c = 'TestPublic');
			insert communitySettings;

			brLghtIdeasSettings__c notificationSettings = new brLghtIdeasSettings__c(Name = 'email_notification');
			notificationSettings.Value__c = '{"active":false, "template":"NewCommentNotificationToIdeaOwner"}';

			insert notificationSettings;

			brLghtIdeasSettings__c statusUpdateSettings = new brLghtIdeasSettings__c(Name = 'status_update');
			statusUpdateSettings.Value__c = '{"active":false, "threshold":20, "original_status":"New", "new_status":"Accepted"}';

			insert statusUpdateSettings;

			brLghtIdeasCategories__c customCategory = new brLghtIdeasCategories__c(Name = 'Category 1', Label__c = 'Category 1', Zone__c = 'TestPublic');
			insert customCategory;

			cId = brLghtIdeasHelper.getCommunityId('');

			if (cId == NULL || cId == '') {
				throw new brIdeasSetupException('To succesfully run the tests you need to crete a Zone with Name="TestPublic"');
			}

			User testUser = new User(Alias = 'testusr', Email = 'testusr@testorg.com',
					EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
					LocaleSidKey = 'en_US', ProfileId = stdUserProfile.Id,
					TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testusr@testorg.com');

			ideasList = new List<Idea>();
			ideasList.add(new Idea(Title = 'Test idea_1', Body = 'Body of test idea_1', Status = 'New', Categories = 'test_1', CommunityId = cId));
			ideasList.add(new Idea(Title = 'Test idea_2', Body = 'Body of test idea_2', Status = 'Delivered', Categories = 'test_1', CommunityId = cId));
			ideasList.add(new Idea(Title = 'Test idea_3', Body = 'Body of test idea_3', Status = 'New', Categories = 'test_2', CommunityId = cId));
			ideasList.add(new Idea(Title = 'Test idea_4', Body = 'Body of test idea_4', Status = 'New', Categories = 'test_2', CommunityId = cId));

			System.assertEquals(4, ideasList.size(), 'Invalid number of ideas to insert');

			insert ideasList;

			testIdea_1 = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];

			insert new IdeaComment(CommentBody = 'First comment', IdeaId = testIdea_1.Id);

			System.runAs(testUser) {
				ideasList = new List<Idea>();
				ideasList.add(new Idea(Title = 'Test idea_5', Body = 'Body of test idea_5', Status = 'New', Categories = 'test_3', CommunityId = cId));
				ideasList.add(new Idea(Title = 'Test idea_6', Body = 'Body of test idea_6', Status = 'New', Categories = 'test_2', CommunityId = cId));
				ideasList.add(new Idea(Title = 'Test idea_7', Body = 'Body of test idea_7', Status = 'Delivered', Categories = 'test_2', CommunityId = cId));
				ideasList.add(new Idea(Title = 'Test idea_8', Body = 'Body of test idea_8', Status = 'New', Categories = 'test_2', CommunityId = cId));

				System.assertEquals(4, ideasList.size(), 'Invalid number of ideas to insert');

				insert ideasList;

				insert new Vote(ParentId = testIdea_1.Id, Type = 'Up');
				insert new IdeaComment(CommentBody = 'Second comment', IdeaId = testIdea_1.Id);
			}
		}
		Test.stopTest();
    }

	@isTest
	public static void testGetUserInfo() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Map<String, String> uInf = brLghtIdeasController.getUserInfo();

			System.assertEquals(true, String.isNotEmpty(uInf.get('Id')), 'Id property is empty');
			System.assertEquals(true, String.isNotEmpty(uInf.get('Name')), 'Name property is empty');
			System.assertEquals(true, String.isNotEmpty(uInf.get('Username')), 'Username property is empty');
			System.assertEquals(true, String.isNotEmpty(uInf.get('Email')), 'Email property is empty');
			System.assertEquals(true, String.isNotEmpty(uInf.get('Type')), 'Type property is empty');
		}
		Test.stopTest();
	}

	@isTest
	public static void testGetIdeas() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			String communityName = '';
			Map<String, String> filterData = new Map<String, String>();
			String cId = brLghtIdeasHelper.getCommunityId(communityName);
			Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_2' LIMIT 1];
			List<Idea> resultList;

			resultList = brLghtIdeasController.getIdeas(communityName, filterData, 1, 10, '');

			System.assertEquals(true, resultList.size() > 0, 'No items retrieved');

			//test pagination
			resultList = brLghtIdeasController.getIdeas(communityName, filterData, 1, 5, '');

			System.assertEquals(5, resultList.size(), 'Wrong number of first page items');

			resultList = brLghtIdeasController.getIdeas(communityName, filterData, 2, 5, '');

			System.assertEquals(3, resultList.size(), 'Wrong number of second page items');

			//test filters
			filterData.put('status', 'New');
			resultList = brLghtIdeasController.getIdeas(communityName, filterData, 1, 10, '');

			System.assertEquals(6, resultList.size(), 'Wrong number of items filtered by Status');

			filterData.put('category', 'test_1');
			resultList = brLghtIdeasController.getIdeas(communityName, filterData, 1, 10, '');

			System.assertEquals(1, resultList.size(), 'Wrong number of items filtered by Status and Category');

			filterData = new Map<String, String>();
			filterData.put('showBy', 'createdByMe');
			resultList = brLghtIdeasController.getIdeas(communityName, filterData, 1, 10, '');

			System.assertEquals(4, resultList.size(), 'Wrong number of items filtered by CreatedByMe');

			filterData = new Map<String, String>();
			filterData.put('showBy', 'commentedByMe');
			resultList = brLghtIdeasController.getIdeas(communityName, filterData, 1, 10, '');

			System.assertEquals(1, resultList.size(), 'Wrong number of items filtered by CommentedByMe');

			//test search
			filterData.put('search', 'search');
			resultList = brLghtIdeasController.getIdeas(communityName, filterData, 1, 10, '');

			System.assertEquals(0, resultList.size(), 'Failed on search test'); //SOSL queries return empty results within test invironment

			//test order by
			filterData = new Map<String, String>();

			List<Idea> defaultOrderByRes = brLghtIdeasController.getIdeas(communityName, filterData, 1, 10, '');
			List<Idea> trendingOrderByRes = brLghtIdeasController.getIdeas(communityName, filterData, 1, 10, 'Trending');
			List<Idea> popularOrderByRes = brLghtIdeasController.getIdeas(communityName, filterData, 1, 10, 'Popular');

			//Order by is unpredictable within tests so just check if rows were retrieved
			System.assertEquals(true, defaultOrderByRes.size() > 0, 'Order by default failed');
			System.assertEquals(true, trendingOrderByRes.size() > 0, 'Order by Trending failed');
			System.assertEquals(true, popularOrderByRes.size() > 0, 'Order by Popular failed');
		}
		Test.stopTest();
	}

	@isTest
	static void getGetIdea() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Idea testItem = [SELECT Id FROM Idea WHERE Title = 'Test idea_2'];

			Idea testIdea = brLghtIdeasController.getIdea(testItem.Id);

			System.assertEquals('Test idea_2', testIdea.Title);
		}
		Test.stopTest();
	}

	@isTest
	static void testGetIdeasCount() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			String communityName = '';
			Map<String, String> filterData = new Map<String, String>();
			Integer countVal;

			countVal = brLghtIdeasController.getIdeasCount(communityName, filterData);

			System.assertEquals(8, countVal, 'Ivalid count without filter');

			filterData.put('category', 'test_2');
			countVal = brLghtIdeasController.getIdeasCount(communityName, filterData);

			System.assertEquals(5, countVal, 'Ivalid count with category filter');

			filterData.put('status', 'Delivered');
			countVal = brLghtIdeasController.getIdeasCount(communityName, filterData);

			System.assertEquals(1, countVal, 'Ivalid count with category and status filter');
		}
		Test.stopTest();
	}

	@isTest
	static void testCreateNewIdea() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Map<String, String> fields = new Map<String, String>();
			fields.put('community', '');
			fields.put('title', 'Test idea_created');
			fields.put('body', 'Body of test idea_created');
			fields.put('status', 'New');
			fields.put('category', 'test_1');

			Idea newIdea = brLghtIdeasController.createNewIdea(fields);

			Idea testItem = [SELECT Title FROM Idea WHERE Id = :newIdea.Id];

			System.assertEquals('Test idea_created', testItem.Title);
		}
		Test.stopTest();
	}

	@isTest
	static void testGetFilterOptions() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Map<String, String> options = new Map<String, String>();
			Map<String, List<Map<String, String>>> data;

			data = brLghtIdeasController.getFilterOptions(options);

			System.assertEquals(true, data.containsKey('category'));
			System.assertEquals(true, data.containsKey('status'));

			options.put('categoriesSource', 'Custom Settings');
			options.put('zone', 'TestPublic');

			data = brLghtIdeasController.getFilterOptions(options);

			System.assertEquals(1, data.get('category').size());
			System.assertEquals('Category 1', data.get('category').get(0).get('value'));
		}
		Test.stopTest();
	}

	@isTest
	static void testGetIdeaVotes() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];
			List<Vote> vts = brLghtIdeasController.getIdeaVotes(testIdea.Id);

			System.assertEquals(2, vts.size());
		}
		Test.stopTest();
	}

	@isTest
	static void testGetIdeaVotesCount() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];
			Integer vcount = brLghtIdeasController.getIdeaVotesCount(testIdea.Id);

			System.assertEquals(2, vcount);
		}
		Test.stopTest();
	}

	@isTest
	static void testAddVote() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Idea testIdea_1 = [SELECT Id FROM Idea WHERE Title = 'Test idea_2' LIMIT 1];
			Idea testIdea_2 = [SELECT Id FROM Idea WHERE Title = 'Test idea_3' LIMIT 1];
			String res;
			User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com'];

			System.runAs(testUser) {
				res = brLghtIdeasController.addVote(testIdea_1.Id, 'Up');

				System.assertEquals('20', res);

				res = brLghtIdeasController.addVote(testIdea_2.Id, 'Down');

				System.assertEquals('0', res);
			}

			res = brLghtIdeasController.addVote(testIdea_1.Id, 'Up');

			System.assertEquals('error', res);
		}
		Test.stopTest();
	}

	@isTest
	static void testAddVoteAndChangeStatus() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {

			Idea testIdea_1 = [SELECT Status FROM Idea WHERE Title = 'Test idea_2' LIMIT 1];
			testIdea_1.Status = 'New';

			update testIdea_1;

			System.assertNotEquals(null, testIdea_1);
			System.assertEquals('New', testIdea_1.Status);

			brLghtIdeasSettings__c settings = [SELECT Value__c FROM brLghtIdeasSettings__c WHERE Name = 'status_update' LIMIT 1];
			settings.Value__c = '{"active":true,"threshold":20,"original_status":"New","new_status":"Accepted"}';

			update settings;

			User testUser = [SELECT Id FROM User WHERE UserName = 'testusr@testorg.com'];

			System.runAs(testUser) {
				String res = brLghtIdeasController.addVote(testIdea_1.Id, 'Up');

				System.assertEquals('20', res);

				String status = brLghtIdeasController.getStatus(testIdea_1.Id);

				System.assertEquals('Accepted', status);

			}
		}
		Test.stopTest();
	}

	@isTest
	static void testGetIdeaComments() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];

			List<IdeaComment> comments = brLghtIdeasController.getIdeaComments(testIdea.Id, '5', 'desc', null);

			System.assertEquals(2, comments.size());
		}
		Test.stopTest();
	}

	@isTest
	static void testGetIdeaCommentsNumber() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];

			Integer commentsNum = brLghtIdeasController.getIdeaCommentsNumber(testIdea.Id);

			System.assertEquals(2, commentsNum);
		}
		Test.stopTest();
	}

	@isTest
	static void testSaveComment() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_1' LIMIT 1];

			IdeaComment testComment = brLghtIdeasController.saveComment(testIdea.Id, 'Test comment');

			System.assertEquals('Test comment', testComment.CommentBody);
		}
		Test.stopTest();
	}

	@isTest
	static void testSaveCommentAndSendEmail() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			Idea testIdea = [SELECT Id FROM Idea WHERE Title = 'Test idea_5' LIMIT 1];

			brLghtIdeasSettings__c settings = [SELECT Value__c FROM brLghtIdeasSettings__c WHERE Name = 'email_notification' LIMIT 1];
			settings.Value__c = '{"active":true,"template":"NewCommentNotificationToIdeaOwner"}';

			update settings;

			System.assertNotEquals(null, settings.Id);

			IdeaComment testComment = brLghtIdeasController.saveComment(testIdea.Id, 'Test comment');

			System.assertEquals('Test comment', testComment.CommentBody);
		}
		Test.stopTest();
	}

	@isTest
	static void testGetSimilarIdeas() {
		User user = [SELECT Id FROM User WHERE UserName = 'sysUserBaker@test.com'];

		Test.startTest();

		System.runAs(user) {
			List<Idea> similar = brLghtIdeasController.getSimilarIdeas('', 'Test idea_1'); //Ideas.findSimilar() doesn't work in test environment

			System.assertEquals(0, similar.size());
		}
		Test.stopTest();
	}
}