public with sharing class brIdeaServiceSelector {

    /**
     * Returns zone list by network id
     *
     * {@inheritDoc}
     *
     * @param       networkId     String
     * @return      zones
     * @see         List<Community>
     */
    public static List<Community> getZoneList(String networkId) {

        List<Community> zoneList = new List<Community>();
        zoneList = [
                SELECT id, NetworkId
                FROM Community
                WHERE NetworkId = :networkId
        ];
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
        listIdea = [
                SELECT id
                FROM Idea
                WHERE CommunityId IN :zoneList
        ];
        return listIdea;

    }

}