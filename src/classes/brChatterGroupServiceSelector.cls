public with sharing class brChatterGroupServiceSelector {

    /**
     * Returns chatters group what exit in ids
     *
     * {@inheritDoc}
     *
     * @param       ids     String
     * @return      list chatter group
     * @see         List<SObject>
     */
    public static List<SObject> getChatterGroup(List<Id> ids) {
        try {
            List<SObject> groupList = new List<SObject>();
            List<SObject> groupS1 = [SELECT id, Name FROM CollaborationGroup WHERE id in :ids];

            for (Id soid : ids) {
                for (SObject so : groupS1) {
                    if (soid == so.get('id')) {
                        groupList.add(so);
                    }
                }
            }

            return groupList;
        } catch (Exception e) {System.debug(e.getMessage());return null;}
    }

    /**
     * Returns chatter group id
     *
     * {@inheritDoc}
     *
     * @return      chatter group id
     * @see         Id
     */
    public static Id getListId() {
        try {
            List<ListView> listViews = [SELECT Id, Name FROM ListView WHERE SobjectType = 'CollaborationGroup' and Name = 'Active Groups'];
            if (listViews.size() > 0) {
                return listViews[0].id;
            } else {
                return null;
            }
        } catch (Exception e) {System.debug(e.getMessage());return null;}
    }

}