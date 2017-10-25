public with sharing class BrEventsHelper {
    public static String networkPrefix;

    public static Boolean performAccessCheck(String accessType, String objectName, List<String> fieldNames) {
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();

        if(accessType == 'read'){
            if(!objectDescribe.isAccessible()){
                return false;
            }

            if(fieldNames != null){
                Map<String, SObjectField> fields = objectDescribe.fields.getMap();
                for (String fieldName: fieldNames) {
                    if(!fields.get(fieldName).getDescribe().isAccessible()){
                        return false;
                    }
                }
            }
            return true;
        }
        else if(accessType == 'create'){
            if(!objectDescribe.isCreateable()){
                return false;
            }

            if(fieldNames != null){
                Map<String, SObjectField> fields = objectDescribe.fields.getMap();
                for (String fieldName: fieldNames) {
                    if(!fields.get(fieldName).getDescribe().isCreateable()){
                        return false;
                    }
                }
            }
            return true;
        }
        else if(accessType == 'edit'){
            if(!objectDescribe.isUpdateable()){
                return false;
            }

            if(fieldNames != null){
                Map<String, SObjectField> fields = objectDescribe.fields.getMap();
                for (String fieldName: fieldNames) {
                    if(!fields.get(fieldName).getDescribe().isUpdateable()){
                        return false;
                    }
                }
            }
            return true;
        }
        else {
            return false;
        }
    }

    public static String compileWhereStatement(Map<String,String> filterData) {
        List<String> whereList = new List<String>();
        List<String> searchIds = new List<String>();
        String searchQuery, tab, selectedDate;

        if (filterData == null) return '';

        searchQuery = filterData.get('search');
        tab = filterData.get('tab');
        selectedDate = filterData.get('date');

        if (String.isNotBlank(searchQuery)) {
            String query = 'FIND \'' + searchQuery + '*\' IN ALL FIELDS RETURNING lovandos__BR_Event__c(Id)';
            List<List<SObject>> searchList = search.query(query);

            for (SObject obj : searchList[0]) {
                searchIds.add(obj.Id);
            }

            whereList.add('Id IN (\'' + String.join(searchIds, '\',\'') + '\')');
        }
        else if(String.isNotBlank(selectedDate)){
            List<String> dateArr = selectedDate.split('-');

            if(dateArr.size() > 0 && String.isNotBlank(dateArr[0]) && String.isNotBlank(dateArr[1])
                    && String.isNotBlank(dateArr[2])){
                Integer yearInt = Integer.valueOf(dateArr[0]);
                Integer monthInt = Integer.valueOf(dateArr[1]);
                Integer dayInt = Integer.valueOf(dateArr[2]);
                DateTime selectedDateStartGMT = DateTime.newInstanceGMT(yearInt, monthInt, dayInt);
                DateTime selectedDateEndGMT = DateTime.newInstanceGMT(yearInt, monthInt, dayInt, 23, 59, 0);

                whereList.add('lovandos__Start_Date__c > ' + selectedDateStartGMT.formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'') + ' AND lovandos__Start_Date__c < '
                        + selectedDateEndGMT.formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\''));
            }
        }
        else if(String.isNotBlank(tab) && tab == 'Attending'){
            whereList.add('Id IN (SELECT lovandos__BR_Event__c FROM lovandos__BR_Participation__c WHERE lovandos__User__c = \'' +
                    UserInfo.getUserId() +'\' AND lovandos__Participate__c = \'Yes\')');
        }

        return String.join(whereList, ' AND ');
    }

    @future
    public static void insertUser(Id userId) {
        PermissionSet ps = [SELECT Id From PermissionSet WHERE Name = 'Bedrock_Events'];
        insert new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = ps.Id);
    }

    public static String getImageSource() {
        String imageSource = lovandos.BrEventsHelper.getConfigValue('image source');

        if(String.isNotBlank(imageSource)){
            return imageSource;
        }

        return '';
    }


    public static String getConfigValue(String name) {
        List<lovandos__BrEvents_Settings__c> settings = [SELECT lovandos__Value__c FROM lovandos__BrEvents_Settings__c WHERE Name = :name LIMIT 1];

        if(settings.size() > 0){
            return settings[0].lovandos__Value__c;
        }
        else {
            return '';
        }
    }

    public static Map<Id, Map<Id, String>> getAttachmentsForItems(Set<Id> items_ids, String imageSource){
        Map<Id, Map<Id, String>> itemsAttachments = new Map<Id, Map<Id, String>>();

        if(items_ids.size() == 0 || !lovandos.BrEventsHelper.performAccessCheck('read', 'Attachment', null)
                || !lovandos.BrEventsHelper.performAccessCheck('read', 'ContentDocumentLink', null))
            return itemsAttachments;

        //if image source equals 'files' get Chatter Files otherwise regular Attachments
        if(imageSource == 'files'){
            List<ContentDocumentLink> chatterFiles = [SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.Title, LinkedEntityId
                                                        FROM ContentDocumentLink WHERE LinkedEntityId IN :items_ids];

            for (ContentDocumentLink file: chatterFiles) {
                if(!itemsAttachments.containsKey(file.LinkedEntityId)){
                    itemsAttachments.put(file.LinkedEntityId, new Map<Id, String>());
                }
                itemsAttachments.get(file.LinkedEntityId).put(file.ContentDocument.LatestPublishedVersionId, file.ContentDocument.Title);
            }
        }
        else {
            List<Attachment> attachments = [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN :items_ids AND ContentType LIKE 'image%'];

            for (Attachment att: attachments) {
                if(!itemsAttachments.containsKey(att.ParentId)){
                    itemsAttachments.put(att.ParentId, new Map<Id, String>());
                }
                itemsAttachments.get(att.ParentId).put(att.Id, att.Name);
            }
        }

        return itemsAttachments;
    }

    @future
    public static void updateParticipateOnChangeEventDate(Set<Id> eventIds) {
        List<lovandos__BR_Participation__c> updatedParticipation = new List<lovandos__BR_Participation__c>();
        List<lovandos__BR_Participation__c> participations = [SELECT Id FROM lovandos__BR_Participation__c
        WHERE lovandos__BR_Event__c IN :eventIds];

        for (lovandos__BR_Participation__c participation : participations) {
            participation.lovandos__TriggerSendReminderWorkflow__c = false;
            updatedParticipation.add(participation);
        }

        update updatedParticipation;

        updatedParticipation.clear();

        for (lovandos__BR_Participation__c participation : participations) {
            participation.lovandos__TriggerSendReminderWorkflow__c = true;
            updatedParticipation.add(participation);
        }
        update updatedParticipation;
    }
}