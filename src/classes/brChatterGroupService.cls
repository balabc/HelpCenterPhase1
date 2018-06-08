public with sharing class brChatterGroupService {

    /**
     * Returns chatters group what exist in ids
     *
     * {@inheritDoc}
     *
     * @param       ids     String
     * @return      list chatter group
     * @see         List<SObject>
     */
    public static List<brChatterGroupModel> getChatterGroupByStringId(String ids) {
        List<Id> groupIds = new List<Id>();
        if (String.isNotBlank(ids)) {
            if (ids.contains(',')) {
                List<String> splitArray = ids.split(',');
                if (splitArray.size() > 4) {
                    for (Integer i = 0; i < 4; i++) {
                        groupIds.add(splitArray[i].trim());
                    }
                }
                for (String str : splitArray) {
                    groupIds.add(str.trim());
                }
            } else {
                groupIds.add(ids);
            }
        }
        if (groupIds.size() > 0) {
            brSecurityService.performAccessCheck('read', 'CollaborationGroup', new List<String>{
                    'Name'
            });

            List<SObject> listGroups = brChatterGroupServiceSelector.getChatterGroup(groupIds);
            List<brChatterGroupModel> chatterGroupModels = new List<brChatterGroupModel>();
            for (SObject gr : listGroups) {
                brChatterGroupModel cls = new brChatterGroupModel();
                cls.id = String.valueOf(gr.get('Id'));
                cls.name = String.valueOf(gr.get('Name'));
                chatterGroupModels.add(cls);
            }
            return chatterGroupModels;
        } else {
            return null;
        }

    }

    /**
     * Returns id list
     *
     * {@inheritDoc}
     *
     * @return      id list
     * @see         Id
     */
    public static Id getListId() {
        brSecurityService.performAccessCheck('read', 'ListView', new List<String>{
                'Name', 'SobjectType'
        });

        return brChatterGroupServiceSelector.getListId();
    }

}