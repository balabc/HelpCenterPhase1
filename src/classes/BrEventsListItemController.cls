public with sharing class BrEventsListItemController {

    @AuraEnabled
    public static String rsvpEvent(Id recordId, String rsvpType, Integer attendeesLimit){
        if(String.isBlank(recordId) || String.isBlank(rsvpType)){
            return 'error';
        }

        if (UserInfo.getUserType() == 'Guest')
            return 'auth_required';

        List<String> participationFieldsToUpdate = new List<String>();
        participationFieldsToUpdate.add('Participate__c');
        List<String> participationFieldsToCreate = new List<String>();
        participationFieldsToCreate.add('BR_Event__c');
        participationFieldsToCreate.add('Participate__c');
        participationFieldsToCreate.add('User__c');

        if(!BrEventsHelper.performAccessCheck('read', 'BR_Participation__c', null)
                || !BrEventsHelper.performAccessCheck('edit', 'BR_Participation__c', participationFieldsToUpdate)
                || !BrEventsHelper.performAccessCheck('create', 'BR_Participation__c', participationFieldsToCreate)){
            return 'error';
        }

        String count_query = 'SELECT COUNT() FROM BR_Participation__c WHERE BR_Event__c = \'' + recordId + '\' AND Participate__c  = \'Yes\'';

        attendeesLimit = Integer.valueOf(attendeesLimit);

        if(attendeesLimit != 0 && rsvpType == 'Yes'){
            Integer attendeesCount = Database.countQuery(count_query);

            if(attendeesCount != 0 && attendeesCount >= attendeesLimit){
                return 'limit_exceded';
            }

        }

        List<BR_Participation__c> participations = [SELECT Id FROM BR_Participation__c
        WHERE BR_Event__c = :recordId
        AND User__c = :UserInfo.getUserId() LIMIT 1];

        BR_Participation__c p = new BR_Participation__c();

        if(participations.size() > 0){
            p = participations[0];
            p.Participate__c = rsvpType;
        } else {
            p.BR_Event__c = recordId;
            p.Participate__c = rsvpType;
            p.User__c = UserInfo.getUserId();
        }

        try {
            upsert p;

            return String.valueOf(Database.countQuery(count_query));
        }
        catch (DmlException e) {
            System.debug(e.getMessage());

            return 'error';
        }
    }
}