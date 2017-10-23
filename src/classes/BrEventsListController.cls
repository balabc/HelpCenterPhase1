public with sharing class BrEventsListController {
    private static final Integer DEFAULT_ITEMS_PER_PAGE = 5;
    private static final Integer MAX_ITEMS_PER_PAGE = 500;

    @AuraEnabled
    public static List<BrEventsWrapper> getEvents(String zoneId, Map<String,String> filterData, Integer page, Integer itemsPerPage){
        List<BrEventsWrapper> wrap_items = new List<BrEventsWrapper>();

        if(!BrEventsHelper.performAccessCheck('read', 'BR_Event__c', null)
                || !BrEventsHelper.performAccessCheck('read', 'BR_Participation__c', null))
            return wrap_items;

/*        DateTime dT = DateTime.now();
        String currentTimeGMT = dT.formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');
        String todayEndTimeGMT = DateTime.newinstance(dT.year(), dT.month(), dT.day(), 23, 59, 0).formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');*/

        String queryFields = 'Id, Name, Description__c, Venue_Address__c, Location__Latitude__s, Location__Longitude__s, Start_Date__c, End_Date__c, Limit_of_attendees__c, ' +
                'List_Image_Filename__c, Enrollment_not_required__c, CreatedBy.Name, CreatedBy.SmallPhotoUrl, CreatedById, (SELECT Participate__c FROM BR_Participations__r WHERE User__c = \'' + UserInfo.getUserId() +'\')';
        String query = 'SELECT ' + queryFields + ' FROM BR_Event__c'
                +' WHERE BR_Events_Zone__c = \'' + zoneId + '\'';

        String tab = filterData.get('tab');
        String queryOrder = 'ASC';

        if(String.isNotBlank(tab) && tab == 'Past'){
            query += ' AND Start_Date__c < TODAY';
            queryOrder = 'DESC';
        } else {
            query += ' AND Start_Date__c > YESTERDAY';
        }

        String queryWhere = BrEventsHelper.compileWhereStatement(filterData);

        page = Integer.valueOf(page);
        itemsPerPage = Integer.valueOf(itemsPerPage);

        if (itemsPerPage < 1 || itemsPerPage > MAX_ITEMS_PER_PAGE) itemsPerPage = DEFAULT_ITEMS_PER_PAGE;

        query += String.isNotBlank(queryWhere) ? ' AND ' + queryWhere : '';
        query += (UserInfo.getUserType() == 'Guest') ? ' AND Publicly_available__c = true' : '';
        query += ' ORDER BY Start_Date__c ' + queryOrder;
        query += ' LIMIT ' + itemsPerPage;
        query += (page > 1) ? ' OFFSET ' + String.valueOf(itemsPerPage*(page-1)) : '';
        System.debug(query);
        List<BR_Event__c> query_items = Database.query(query);
//System.debug(query_items);
        if(query_items.size() < 1){
            return wrap_items;
        }

        Set<Id> items_ids = (new Map<Id,BR_Event__c>(query_items)).keySet();
        String imageSource = BrEventsHelper.getImageSource();
        Map<Id, Map<Id, String>> itemsAttachments = BrEventsHelper.getAttachmentsForItems(items_ids, imageSource);

        //get attendees count for all events
        List<BR_Participation__c> participations = [SELECT BR_Event__c FROM BR_Participation__c WHERE BR_Event__c IN :items_ids AND Participate__c  = 'Yes'];

        Map<Id, Integer> itemsParticipations = new Map<Id, Integer>();

        for (BR_Participation__c part: participations){
            if(itemsParticipations.containsKey(part.BR_Event__c)){
                itemsParticipations.put(part.BR_Event__c, itemsParticipations.get(part.BR_Event__c) + 1);
            }
            else {
                itemsParticipations.put(part.BR_Event__c, 1);
            }
        }

        //put all items data to wrapper object
        for (BR_Event__c item: query_items){
            BrEventsWrapper bew = new BrEventsWrapper();
            bew.item = item;
            bew.listImageURL = '';

            for(Id item_id: itemsAttachments.keySet()){
                Map<Id, String> itemAttachments = itemsAttachments.get(item_id);
                for (Id attId: itemAttachments.keySet()){
                    if(item.List_Image_Filename__c == itemAttachments.get(attId)){
                        if(imageSource == 'files'){
                            bew.listImageURL = '/sfc/servlet.shepherd/version/download/' + attId;
                        }
                        else {
                            bew.listImageURL = '/servlet/servlet.FileDownload?file=' + attId;
                        }
                    }
                }
            }

            if(itemsParticipations.containsKey(item.Id)){
                bew.attendeesCount = itemsParticipations.get(item.Id);
            }
            else {
                bew.attendeesCount = 0;
            }

            bew.itemDates = item.Start_Date__c.format();

            if(item.End_Date__c != null){
                if(item.End_Date__c > item.Start_Date__c){
                    bew.itemDates = item.Start_Date__c.format() + ' - ' + item.End_Date__c.format();
                }
            }

            wrap_items.add(bew);
        }

        return wrap_items;
    }


    @AuraEnabled
    public static Integer getEventsCount(String zoneId, Map<String,String> filterData) {
        Integer result_count = 0;

        if(!BrEventsHelper.performAccessCheck('read', 'BR_Event__c', null))
            return result_count;

//        String currentTimeGMT = DateTime.now().formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');

        String query = 'SELECT COUNT() FROM BR_Event__c'
                +' WHERE BR_Events_Zone__c = \'' + zoneId + '\'';

        String tab = filterData.get('tab');

        if(String.isNotBlank(tab) && tab == 'Past'){
            query += ' AND Start_Date__c < TODAY';
        } else {
            query += ' AND Start_Date__c > YESTERDAY';
        }

        String queryWhere = BrEventsHelper.compileWhereStatement(filterData);

        query += String.isNotBlank(queryWhere) ? ' AND ' + queryWhere : '';
        query += (UserInfo.getUserType() == 'Guest') ? ' AND Publicly_available__c = true' : '';

        result_count = Database.countQuery(query);

        return result_count;
    }
}