public with sharing class brIdeaService {

    /**
     * Returns count ideas in community
     *
     * {@inheritDoc}
     *
     * @param       communityId     Id
     * @return      count ideas
     * @see         Integer
     */
    public static Integer getIdeaCount(Id communityId) {

        List<Community> zoneList = brIdeaServiceSelector.getZoneList(communityId);
        if (zoneList.size() > 0) {
            return brIdeaServiceSelector.getIdeaList(zoneList).size();
        } else {
            return 0;
        }

    }

}