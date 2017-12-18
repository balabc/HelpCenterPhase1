/**
 *  This class is controller for brCommunityLandingTile aura component
 */
public with sharing class brCommunityLandingTileCtrl {
    /**
     *
     *
     * @return CollaborationGroup object
     */
    @AuraEnabled
    public static ListView getListViews() {
        ListView view = [SELECT Id, SobjectType FROM ListView
                                    WHERE SobjectType = 'CollaborationGroup'
                                    AND Name = 'Active Groups'
                                    LIMIT 1];

        return view;
    }

}