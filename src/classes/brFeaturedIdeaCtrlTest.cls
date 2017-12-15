
@IsTest
private class brFeaturedIdeaCtrlTest {

    static testMethod void testGetFeaturedIdeaData() {

        String ideaId = '';

        Test.startTest();
            brFeaturedIdeaCtrl.featuredIdeaData data = brFeaturedIdeaCtrl.getFeaturedIdeaData(ideaId);
        Test.stopTest();

        System.assertNotEquals(null, data);
    }

    static testMethod void testCutText() {

        String inputText = '<p>One morning, when Gregor Samsa woke from troubled dreams, he found himself transformed in his bed into a horrible vermin.He lay on his armour-like back, and if he lifted his head a little he could see his brown belly, slightly domed and divided by arches into stiff sections. The bedding was hardly able to cover it and seemed ready to slide off any moment. His many legs, pitifully thin compared with the size of the rest of him, waved about helplessly as he looked.</p>';

        Test.startTest();
            String outputText  = brFeaturedIdeaCtrl.cutText(inputText);
        Test.stopTest();

        System.assertNotEquals(null, outputText);
        System.assertEquals(-1, outputText.indexOfAny('<p>'));
        System.assertEquals(203, outputText.length());//200 w\o "..."
    }

    static testMethod void testGetIdeaData() {

        Idea ideaObjBlank = new Idea();

        Community community = [SELECT Id FROM Community LIMIT 1];// WHERE Name = 'TestPublic'
        String cId = community.Id;

        Idea ideaObjOne = new Idea();
        ideaObjOne.Title = 'Test Tittle';
        ideaObjOne.Body = '<p>Kinda some smart sentence</p>';
        ideaObjOne.CommunityId = cId;//Community = Idea Zone
        insert ideaObjOne;

        Test.startTest();
            Idea ideaObj  = brFeaturedIdeaCtrl.getIdeaData(ideaObjOne.Id);
        Test.stopTest();

        System.assertNotEquals(ideaObjBlank, ideaObj);
        System.assertEquals('Test Tittle', ideaObj.Title);
        System.assertEquals('<p>Kinda some smart sentence</p>', ideaObj.Body);

    }
    static testMethod void testGetIdeaData_Negative() {

        String ideaId = '';
        Idea ideaObjBlank = new Idea();

        Test.startTest();
            Idea ideaObj  = brFeaturedIdeaCtrl.getIdeaData(ideaId);
        Test.stopTest();

        System.assertEquals(ideaObjBlank, ideaObj);
    }

}