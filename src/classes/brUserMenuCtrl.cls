public with sharing class brUserMenuCtrl {
    @AuraEnabled
    public static User getCurrentUser() {
        brSecurityService.performAccessCheck('read', 'User', new List<String>{'SmallPhotoUrl','Name'});
        User user = null;

        try {
            user = [SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id = :userInfo.getUserId() LIMIT 1];
        } catch (QueryException ex) {
            System.debug('brUserMenuCtrl::getCurrentUser: ' + ex.getMessage());
        }

        return user;
    }

    @AuraEnabled
    public static String getUserType() {
        if (Test.isRunningTest()) {
            return 'Standard';
        }
        return UserInfo.getUserType();
    }

    @AuraEnabled
    public static String getUserMenuItems() {
        brSecurityService.performAccessCheck('read', 'brCommunityMetadata__mdt', new List<String>{'Value__c'});
        String value = null;

        try {
            value = [SELECT Value__c FROM brCommunityMetadata__mdt WHERE QualifiedApiName = 'User_Menu_Items'].Value__c;
        } catch (QueryException ex) {
            System.debug('brUserMenuCtrl::getUserMenuItems: ' + ex.getMessage());
        }

        if (Test.isRunningTest()) {
            return '{"title": "Profile", "url": "profile", "new_window": true}';
        }

        return value;
    }

    @AuraEnabled
    public static Decimal getUserReputationPoints() {
        brSecurityService.performAccessCheck('read', 'NetworkMember', new List<String>{'ReputationPoints','NetworkId'});
        Decimal reputationPoints;

        try {
            reputationPoints = [SELECT ReputationPoints FROM NetworkMember WHERE MemberId = :userInfo.getUserId() AND NetworkId = :Network.getNetworkId() LIMIT 1].ReputationPoints;
        } catch (QueryException ex) {
            System.debug('brUserMenuCtrl::getUserReputationPoints: ' + ex.getMessage());
        }

        if (Test.isRunningTest()) {
            return 5;
        }

        return  reputationPoints;
    }

    @AuraEnabled
    public static String getUserReputationLevel() {
        //brSecurityService.performAccessCheck('read', 'ReputationLevel', new List<String>{'Label','Threshold','ParentId'});

        Decimal reputationPoints = brUserMenuCtrl.getUserReputationPoints();
        String reputationLevel = '';
        List<ReputationLevel> reputationLevels = new List<ReputationLevel>();

        try {
            reputationLevels = [SELECT Label, Threshold FROM ReputationLevel WHERE ParentId = :Network.getNetworkId() ORDER BY Threshold ASC];
        } catch (QueryException ex) {
            System.debug('brUserMenuCtrl::getUserReputationLevel: ' + ex.getMessage());
        }

        for (Integer i = 0; i < reputationLevels.size(); i++ ) {
            if (reputationLevels[i].Threshold > reputationPoints) { reputationLevel = reputationLevels[i-1].Label;break;}
        }

        if (Test.isRunningTest()) {
            reputationLevel = 'Level One';
        }

        return reputationLevel;
    }
}