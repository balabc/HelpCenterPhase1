/**
 *  This class is controller for brLandingTiles aura component
 */
public with sharing class brLandingTilesCtrl {
    /**
    *
    *
    * @return CollaborationGroup object
    */
    @AuraEnabled
    public static ListView getListViews() {
        ListView view = [   SELECT Id, SobjectType FROM ListView
                            WHERE SobjectType = 'CollaborationGroup'
                            AND Name = 'Active Groups'
                            LIMIT 1];

        return view;
    }

}