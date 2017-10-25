public with sharing class BrEventsItemController {

    @AuraEnabled
    public static BrEventsItemWrapper getEvent(Id recordId){
        if(String.isBlank(recordId) || !BrEventsHelper.performAccessCheck('read', 'BR_Event__c', null)
                || !BrEventsHelper.performAccessCheck('read', 'BR_Participation__c', null))
            return null;

        BrEventsItemWrapper itemWrapper = new BrEventsItemWrapper();
        BR_Event__c item = [SELECT Id, Name, Description__c, Venue_Address__c, Location__Latitude__s, Location__Longitude__s, Start_Date__c,
                End_Date__c, Hide_attendees__c, Limit_of_attendees__c, Main_Image_Filename__c, List_Image_Filename__c, Enrollment_not_required__c,
        (SELECT Participate__c FROM BR_Participations__r WHERE User__c = :UserInfo.getUserId())
        FROM BR_Event__c WHERE Id = :recordId];

        itemWrapper.item = item;
        itemWrapper.itemDate = item.Start_Date__c.format();

        if(item.End_Date__c != null){
            if(item.End_Date__c > item.Start_Date__c){
                itemWrapper.itemDate = item.Start_Date__c.format() + ' - ' + item.End_Date__c.format();
            }
        }

        return itemWrapper;
    }

    @AuraEnabled
    public static Integer getAttendeesCount(Id recordId) {
        if(!BrEventsHelper.performAccessCheck('read', 'BR_Event__c', null))
            return 0;

        String query = 'SELECT COUNT() FROM BR_Participation__c WHERE BR_Event__c = \'' + recordId + '\' AND Participate__c  = \'Yes\'';

        return Database.countQuery(query);
    }

    @AuraEnabled
    public static List<BR_Participation__c> getParticipations(Id recordId){

        if(String.isBlank(recordId) || !BrEventsHelper.performAccessCheck('read', 'BR_Event__c', null))
            return null;

        String rsvpType = 'Yes';

        return [SELECT User__r.Id, User__r.Name, User__r.FirstName, User__r.LastName, User__r.SmallPhotoUrl, Participate__c
                FROM BR_Participation__c WHERE BR_Event__c = :recordId AND Participate__c = :rsvpType];
    }

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

    @AuraEnabled
    public static String getEventMainImage(Id recordId, String mainImageName){

        if(String.isBlank(recordId) || String.isBlank(mainImageName)
                || !BrEventsHelper.performAccessCheck('read', 'Attachment', null)
                || !BrEventsHelper.performAccessCheck('read', 'ContentDocumentLink', null))
            return null;

        String imageSource = BrEventsHelper.getImageSource();

        mainImageName = String.valueOf(mainImageName);

        if(imageSource == 'files'){
            List<ContentDocumentLink> chatterFiles = [SELECT ContentDocument.LatestPublishedVersionId
                                                        FROM ContentDocumentLink WHERE LinkedEntityId = :recordId
                                                            AND ContentDocument.Title = :mainImageName];

            if(chatterFiles.size() > 0){
                return '/sfc/servlet.shepherd/version/download/' + chatterFiles[0].ContentDocument.LatestPublishedVersionId;
            }
        }
        else {
            List<Attachment> attachments = [SELECT Id FROM Attachment
            WHERE ParentId = :recordId
            AND ContentType LIKE 'image%'
            AND Name = :mainImageName];

            if(attachments.size() > 0){
                Id mainImageId = attachments[0].Id;
                return '/servlet/servlet.FileDownload?file=' + mainImageId;
            }
        }

        return null;
    }
}