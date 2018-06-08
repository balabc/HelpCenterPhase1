
@IsTest
private class brFeaturedIdeaCtrlTest {

    @testSetup
    static void setup() {
        User testUser = brTestDataFactory.createTestStandardProfileUser();
        System.assertEquals('sysuserbaker@test.com', testUser.UserName, 'wrong username');
    }

    @isTest
    static void testGetFeaturedIdeaData() {

        String ideaId = '';

        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            brFeaturedIdeaCtrl.featuredIdeaData data = brFeaturedIdeaCtrl.getFeaturedIdeaData(ideaId);
            System.assertNotEquals(null, data);
        }

        Test.stopTest();
    }

    @isTest
    static void testCutText() {

        String inputText = '<p>One morning, when Gregor Samsa woke from troubled dreams, he found himself transformed in his bed into a horrible vermin.He lay on his armour-like back, and if he lifted his head a little he could see his brown belly, slightly domed and divided by arches into stiff sections. The bedding was hardly able to cover it and seemed ready to slide off any moment. His many legs, pitifully thin compared with the size of the rest of him, waved about helplessly as he looked.</p>';

        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Test.startTest();

        System.runAs(testUser) {
            String outputText = brFeaturedIdeaCtrl.cutText(inputText);
            System.assertNotEquals(null, outputText);
            System.assertEquals(-1, outputText.indexOfAny('<p>'));
            System.assertEquals(203, outputText.length());//200 w\o "..."
        }

        Test.stopTest();
    }

    @isTest
    static void testGetIdeaData() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        Idea ideaObjBlank = new Idea();

        Community community = [SELECT Id FROM Community LIMIT 1];// WHERE Name = 'TestPublic'
        String cId = community.Id;

        Idea ideaObjOne = new Idea();
        ideaObjOne.Title = 'Test Tittle';
        ideaObjOne.Body = '<p>Kinda some smart sentence</p>';
        ideaObjOne.CommunityId = cId;//Community = Idea Zone
        insert ideaObjOne;

        Test.startTest();

        System.runAs(testUser) {
            Idea ideaObj = brFeaturedIdeaCtrl.getIdeaData(ideaObjOne.Id);
            System.assertNotEquals(ideaObjBlank, ideaObj);
            System.assertEquals('Test Tittle', ideaObj.Title);
            System.assertEquals('<p>Kinda some smart sentence</p>', ideaObj.Body);
        }

        Test.stopTest();


    }
    @isTest
    static void testGetIdeaData_Negative() {
        User testUser = [SELECT Id, UserName FROM User WHERE UserName = 'sysuserbaker@test.com'];

        String ideaId = '';
        Idea ideaObjBlank = new Idea();

        Test.startTest();

        System.runAs(testUser) {
            Idea ideaObj = brFeaturedIdeaCtrl.getIdeaData(ideaId);
            System.assertEquals(ideaObjBlank, ideaObj);
        }

        Test.stopTest();

    }

}