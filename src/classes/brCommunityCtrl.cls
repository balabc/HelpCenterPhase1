public with sharing class brCommunityCtrl {
    public static Boolean showUserNickname = false;

    @AuraEnabled
    public static String getUserDisplayName(Id userId){
        String displayName = '';
        String ntwrkId = Network.getNetworkId();

        if (ntwrkId != null || Test.isRunningTest()) {
            try {
                Network currNtwrk = brCommunityHelper.getNetworkById(ntwrkId);
                brCommunityCtrl.showUserNickname = Boolean.valueOf(currNtwrk.OptionsNicknameDisplayEnabled);

            } catch(Exception ex) {
                System.debug('brCommunityCtrl::getUserDisplayName: ' + ex.getMessage());
            }
        }

        try {
            User usr = brCommunityHelper.getUserById(userId);

            if (brCommunityCtrl.showUserNickname && String.isNotBlank(usr.CommunityNickname)) {
                displayName = usr.CommunityNickname;
            } else {
                displayName = usr.FirstName + ' ' + usr.LastName;
            }

        } catch(Exception ex) {
            System.debug('brCommunityCtrl::getUserDisplayName: ' + ex.getMessage());
        }

        return displayName;
    }

}