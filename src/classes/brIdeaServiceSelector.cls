public with sharing class brIdeaServiceSelector {

    /**
     * Returns zone list by network id
     *
     * {@inheritDoc}
     *
     * @return      zones
     * @see         List<Community>
     */
    public static List<Community> getZoneList() {

        List<Community> zoneList = new List<Community>();
        try {
            zoneList = [
                    SELECT id, NetworkId
                    FROM Community
                    WHERE NetworkId = :brNetwork.getNetworkId()
            ];
        } catch (Exception e) {
            System.debug(e.getMessage());
            zoneList = null;
        }
        return zoneList;

    }

    /**
     * Returns ideas list in zone list
     *
     * {@inheritDoc}
     *
     * @param       zoneList     List<Community>
     * @return      ideas
     * @see         List<Idea>
     */
    public static List<Idea> getIdeaList(List<Community> zoneList) {

        List<Idea> listIdea = new List<Idea>();
        try {
            listIdea = [
                    SELECT id
                    FROM Idea
                    WHERE CommunityId IN :zoneList
            ];
        } catch (Exception e) {
            System.debug(e.getMessage());
            listIdea = null;
        }
        return listIdea;

    }

}