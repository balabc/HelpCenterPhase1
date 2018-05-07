public with sharing class brIdeaService {

    /**
     * Returns count ideas in community
     *
     * {@inheritDoc}
     *
     * @return      count ideas
     * @see         Integer
     */
    public static Integer getIdeaCount() {
        brSecurityService.performAccessCheck('read', 'Community', new List<String>{'NetworkId'});
        brSecurityService.performAccessCheck('read', 'Idea', new List<String>{'CommunityId'});

        List<Community> zoneList = brIdeaServiceSelector.getZoneList();
        if (zoneList.size() > 0) {
            return brIdeaServiceSelector.getIdeaList(zoneList).size();
        } else {
            return 0;
        }

    }

}