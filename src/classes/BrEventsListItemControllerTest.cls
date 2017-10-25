@IsTest
private class BrEventsListItemControllerTest {

    @testSetup static void setup() {
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
            String result = BrEventsListItemController.rsvpEvent(recordId, rsvpType, attendeesLimit);
            System.assertEquals('error', result, 'item id is empty');

            //rsvpType is empty
            recordId = item.Id;
            rsvpType = '';
            result = BrEventsListItemController.rsvpEvent(recordId, rsvpType, attendeesLimit);
            System.assertEquals('error', result, 'rsvpType is empty');

            rsvpType = 'No';
            result = BrEventsListItemController.rsvpEvent(recordId, rsvpType, attendeesLimit);
            System.assertEquals('0', result, 'wrong number of attendees');

            rsvpType = 'Yes';
            result = BrEventsListItemController.rsvpEvent(recordId, rsvpType, attendeesLimit);
            System.assertEquals('1', result, 'wrong number of attendees');
        }

        User testUser = [SELECT Id FROM User WHERE Username = 'testusr2@testorg.com'];

        System.runAs(testUser){
            //attendeesLimit more than current number of attendees, current attendees number is 1
            attendeesLimit = 1;
            recordId = item.Id;
            rsvpType = 'Yes';
            String result = BrEventsListItemController.rsvpEvent(recordId, rsvpType, attendeesLimit);
            System.assertEquals('limit_exceded', result, 'limit of attendees is exceeded');
        }
    }
}