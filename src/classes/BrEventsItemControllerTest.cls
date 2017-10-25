@IsTest
private class BrEventsItemControllerTest {

    @testSetup static void setup() {
        BR_Event__c item = new BR_Event__c(
                Name = 'Test event0',
                Start_Date__c = datetime.newInstance(2016, 10, 15, 12, 30, 0),
                Location__Latitude__s = 51.5156950,
                Location__Longitude__s = -0.0893931,
                Venue_Address__c = 'Test ave 12/20'
        );
        insert item;
        insert new BR_Participation__c(BR_Event__c = item.Id, Participate__c = 'Yes', User__c = UserInfo.getUserId());

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User user = new User(Alias = 'testusr1', Email='testusr1@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey = UserInfo.getTimeZone().getID(), UserName='testusr1@testorg.com');

        insert user;
        System.assertNotEquals(null, user.Id, 'user is not created');
        BrEventsHelper.insertUser(user.Id);

        User testUser = new User(Alias = 'testusr', Email='testusr2@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey=UserInfo.getTimeZone().getID(), UserName='testusr2@testorg.com');

        insert testUser;
        System.assertNotEquals(null, testUser.Id, 'user is not created');
        BrEventsHelper.insertUser(testUser.Id);
    }

    static testMethod void testGetEvent() {
        User user = [SELECT Id FROM User WHERE Username = 'testusr1@testorg.com'];

        System.runAs(user){
            Id recordId;
            BrEventsItemWrapper result = BrEventsItemController.getEvent(recordId);
            System.assertEquals(null, result, 'item id is blank');

            String itemName = 'Test event0';
            BR_Event__c item = [SELECT Id FROM BR_Event__c WHERE Name = :itemName];
            recordId = item.Id;
            result = BrEventsItemController.getEvent(recordId);
            System.assertEquals('Test event0', result.item.Name, 'cannot get event item');
        }
    }

    static testMethod void testGetAttendeesCount() {
        User user = [SELECT Id FROM User WHERE Username = 'testusr1@testorg.com'];

        System.runAs(user){
            String itemName = 'Test event0';
            BR_Event__c item = [SELECT Id FROM BR_Event__c WHERE Name = :itemName];
            Integer result = BrEventsItemController.getAttendeesCount(item.Id);
            System.assertEquals(1, result, 'wrong number of attendees');
        }
    }

    static testMethod void testGetParticipations() {
        User user = [SELECT Id FROM User WHERE Username = 'testusr1@testorg.com'];

        System.runAs(user){
            Id recordId;
            List<BR_Participation__c> result = BrEventsItemController.getParticipations(recordId);
            System.assertEquals(null, result, 'item id is blank');

            String itemName = 'Test event0';
            BR_Event__c item = [SELECT Id FROM BR_Event__c WHERE Name = :itemName];

            recordId = item.Id;
            result = BrEventsItemController.getParticipations(recordId);
            System.assertEquals(1, result.size(), 'wrong number of participations');
        }
    }

    static testMethod void testRsvpEvent() {

        Id recordId;
        String rsvpType = 'Yes';
        Integer attendeesLimit = 0; //attendeesLimit is zero, means no limit

        BR_Event__c item = new BR_Event__c(
                Name = 'Test event1',
                Start_Date__c = datetime.newInstance(2015, 10, 15, 12, 30, 0),
                Location__Latitude__s = 51.5156950,
                Location__Longitude__s = -0.0893931,
                Venue_Address__c = 'Test ave 12/2'
        );
        insert item;

        User user = [SELECT Id FROM User WHERE Username = 'testusr1@testorg.com'];

        System.runAs(user){
            //reecord id is null or empty
            String result = BrEventsItemController.rsvpEvent(recordId, rsvpType, attendeesLimit);
            System.assertEquals('error', result, 'item id is empty');

            //rsvpType is empty
            recordId = item.Id;
            rsvpType = '';
            result = BrEventsItemController.rsvpEvent(recordId, rsvpType, attendeesLimit);
            System.assertEquals('error', result, 'rsvpType is empty');


            rsvpType = 'No';
            result = BrEventsItemController.rsvpEvent(recordId, rsvpType, attendeesLimit);
            System.assertEquals('0', result, 'wrong number of attendees');

            rsvpType = 'Yes';
            result = BrEventsItemController.rsvpEvent(recordId, rsvpType, attendeesLimit);
            System.assertEquals('1', result, 'wrong number of attendees');
        }

        User testUser = [SELECT Id FROM User WHERE Username = 'testusr2@testorg.com'];

        System.runAs(testUser){
            //attendeesLimit more than current number of attendees, current attendees number is 1
            recordId = item.Id;
            attendeesLimit = 1;
            rsvpType = 'Yes';
            String result = BrEventsItemController.rsvpEvent(recordId, rsvpType, attendeesLimit);
            System.assertEquals('limit_exceded', result, 'limit of attendees is exceeded');
        }
    }

    static testMethod void testGetEventMainImage() {
        User user = [SELECT Id FROM User WHERE Username = 'testusr1@testorg.com'];

        System.runAs(user){
            Id recordId;
            String mainImageName = '';

            //reecord id is null or empty
            String result = BrEventsItemController.getEventMainImage(recordId, mainImageName);
            System.assertEquals(null, result, 'item id is empty');

            String itemName = 'Test event0';
            BR_Event__c item = [SELECT Id FROM BR_Event__c WHERE Name = :itemName];
            recordId = item.Id;
            result = BrEventsItemController.getEventMainImage(recordId, mainImageName);
            System.assertEquals(null, result, 'mainImageName is empty');

            mainImageName = 'Attachment0';
            result = BrEventsItemController.getEventMainImage(recordId, mainImageName);
            System.assertEquals(null, result, 'no attachment for this filename');

            Attachment att = new Attachment(Name='Attachment0', Body = Blob.valueOf('Attachment0'), ParentId = item.Id, ContentType = 'image/jpeg');
            insert att;
            result = BrEventsItemController.getEventMainImage(recordId, mainImageName);
            System.assertEquals('/servlet/servlet.FileDownload?file=' + att.Id, result, 'wrong image url returned');
        }
    }
}