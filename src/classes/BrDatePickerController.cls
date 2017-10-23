public with sharing class BrDatePickerController {

    @AuraEnabled
    public static List<BR_Event__c> getEventsForMonth(String zoneId, Integer year, Integer month) {

        List<BR_Event__c> itemsList = new List<BR_Event__c>();

        if(!BrEventsHelper.performAccessCheck('read', 'BR_Event__c', null)
                || !BrEventsHelper.performAccessCheck('read', 'BR_Participation__c', null))
            return itemsList;

        year = Integer.valueOf(year);
        month = Integer.valueOf(month);
        String currentTimeGMT = DateTime.now().formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');
        Integer numberOfDays = Date.daysInMonth(year, month);
        DateTime monthDateStartGMT = DateTime.newInstanceGMT(year, month, 1);
        DateTime monthDateEndGMT = DateTime.newInstanceGMT(year, month, numberOfDays, 23, 59, 0);

        String query = 'SELECT Start_Date__c, (SELECT Participate__c FROM BR_Participations__r' +
                ' WHERE User__c = \'' + UserInfo.getUserId() +'\' AND Participate__c = \'Yes\')' +
                ' FROM BR_Event__c WHERE BR_Events_Zone__c = \'' + zoneId + '\' AND Start_Date__c > YESTERDAY' +
                ' AND Start_Date__c > ' + monthDateStartGMT.formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'') + ' AND Start_Date__c < '
                + monthDateEndGMT.formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');

        query += (UserInfo.getUserType() == 'Guest') ? ' AND Publicly_available__c = true' : '';

        itemsList = Database.query(query);

        return itemsList;
    }
}