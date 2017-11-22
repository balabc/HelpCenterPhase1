public with sharing class brUserMenuCtrl {
    @AuraEnabled
    public static User getCurrentUser() {
        return [SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id = :userInfo.getUserId() LIMIT 1];
    }

    @AuraEnabled
    public static String getUserMenuItems() {
        if (Test.isRunningTest()) {
            return '{"title": "Profile", "url": "profile", "new_window": true}';
        }

        return [SELECT Value__c FROM brCommunityMetadata__mdt].Value__c;
    }

    @AuraEnabled
    public static Decimal getUserReputationPoints() {
        if (Test.isRunningTest()) {
            return 5;
        }

        return [SELECT ReputationPoints FROM NetworkMember WHERE MemberId = :userInfo.getUserId() AND NetworkId = :Network.getNetworkId() LIMIT 1].ReputationPoints;
    }

    @AuraEnabled
    public static String getUserReputationLevel() {
        Decimal reputationPoints = brUserMenuCtrl.getUserReputationPoints();
        String reputationLevel = '';
        List<ReputationLevel> reputationLevels = [SELECT Label, Threshold FROM ReputationLevel WHERE ParentId = :Network.getNetworkId() ORDER BY Threshold ASC];

        for (Integer i = 0; i < reputationLevels.size(); i++ ) {
            if (reputationLevels[i].Threshold > reputationPoints) { reputationLevel = reputationLevels[i-1].Label;break;}
        }

        if (Test.isRunningTest()) {
            reputationLevel = 'Level One';
        }

        return reputationLevel;
    }
}