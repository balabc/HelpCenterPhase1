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
        brSecurityService.performAccessCheck('read', 'ListView', new List<String>{'SobjectType','Name'});
        ListView view = null;

        try {
            view = [
                    SELECT Id, SobjectType
                    FROM ListView
                    WHERE SobjectType = 'CollaborationGroup'
                    AND Name = 'Active Groups'
                    LIMIT 1
            ];
        } catch (QueryException ex) {
            System.debug('brLandingTilesCtrl::getListViews: ' + ex.getMessage());
        }

        return view;
    }

}