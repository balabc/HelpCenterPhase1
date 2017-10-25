@IsTest
private class BrDatePickerControllerTest {
    @testSetup static void setup() {
        List<BR_Event__c> events = new List<BR_Event__c>();

        BR_Events_Zone__c zone = new BR_Events_Zone__c(Name = 'testzone');
        insert zone;

        Integer year = System.today().year() + 1;
        for (Integer i=0;i<7;i++) {
            events.add(new BR_Event__c(
                    Name = 'Test event' + i,
                    Start_Date__c = datetime.newInstance(year, 10, 15+i, 12, 30, 0),
                    Location__Latitude__s = 51.5156950,
                    Location__Longitude__s = -0.0893931,
                    Venue_Address__c = 'Test ave 12/2' + i,
                    List_Image_Filename__c = 'Attachment' + i,
                    BR_Events_Zone__c = zone.Id
            ));
        }
        //add not eligible item
        events.add(new BR_Event__c(
                Name = 'Test event8',
                Start_Date__c = datetime.newInstance(2015, 10, 15, 12, 30, 0),
                Location__Latitude__s = 51.5156950,
                Location__Longitude__s = -0.0893931,
                Venue_Address__c = 'Test ave 12/2'
        ));

        insert events;

        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User user = new User(Alias = 'testusr1', Email='testusr1@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = stdUserProfile.Id,
                TimeZoneSidKey = UserInfo.getTimeZone().getID(), UserName='testusr1@testorg.com');

        insert user;
        System.assertNotEquals(null, user.Id, 'user is not created');
        BrEventsHelper.insertUser(user.Id);
    }

    static testMethod void testGetEventsForMonth() {
        User user = [SELECT Id FROM User WHERE Username = 'testusr1@testorg.com'];
        System.runAs(user) {
            Integer year = System.today().year() + 1;
            Integer month = 10;

            BR_Events_Zone__c zone = [SELECT Id FROM BR_Events_Zone__c WHERE Name = 'testzone' LIMIT 1];
            String zoneId = String.valueOf(zone.Id);

            List<BR_Event__c> itemsList = DatePickerController.getEventsForMonth(zoneId, year, month);
            System.assertEquals(7, itemsList.size(), 'Ivalid number of events for specific month');
        }
    }
}