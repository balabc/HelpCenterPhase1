public without sharing class brIdeaDataSelector {

    public static Map<String, List<String>> getAssignedUserEmailsByCategory(){
        Map<String, List<String>> aMap = new Map<String, List<String>>();
        List<String> categoriesList;

        List<brIdeasCategoriesAssignment__c> assignments = [SELECT User__r.Email, Categories__c
                                                                        FROM brIdeasCategoriesAssignment__c
                                                                        LIMIT 10000];

        for (brIdeasCategoriesAssignment__c assign : assignments) {
            if (assign.User__r.Email == NULL) continue;

            categoriesList = assign.Categories__c.split(';');

            for (String category : categoriesList) {
                if (!aMap.containsKey(category)) {
                    aMap.put(category, new List<String>{assign.User__r.Email});
                } else {
                    aMap.get(category).add(assign.User__r.Email);
                }
            }
        }

        return aMap;
    }


    public static Map<String, List<String>> getSubscribersEmailsByIdeas(Set<String> ideasIds, Boolean ignoreEmailSettings){
        Map<String, List<String>> emailsMap = new Map<String, List<String>>();
        Set<String> allUsers = new Set<String>();
        Set<String> allZones = new Set<String>();

        List<brIdeaSubscription__c> subscrs = [
                SELECT Idea__c, Idea__r.CommunityId, User__c, User__r.Email
                FROM brIdeaSubscription__c
                WHERE Idea__c IN :ideasIds
                LIMIT 10000];

        for (brIdeaSubscription__c subscr : subscrs) {
            allUsers.add(subscr.User__c);
            allZones.add(subscr.Idea__r.CommunityId);
        }

        Map<String, Set<String>> networkUsers = new Map<String, Set<String>>();

        for (NetworkMember membr : [SELECT MemberId, NetworkId, PreferencesDisableAllFeedsEmail
                                        FROM NetworkMember WHERE MemberId IN :allUsers]) {
            if (ignoreEmailSettings == FALSE && membr.PreferencesDisableAllFeedsEmail == TRUE) continue;

            if (networkUsers.get(membr.NetworkId) != NULL) {
                networkUsers.get(membr.NetworkId).add(membr.MemberId);
            } else {
                networkUsers.put(membr.NetworkId, new Set<String>{membr.MemberId});
            }
        }

        Map<String, Set<String>> communityUsers = new Map<String, Set<String>>();

        for (Community zone : [SELECT NetworkId FROM Community WHERE Id IN :allZones]) {
            if (networkUsers.get(zone.NetworkId) == NULL) continue;

            communityUsers.put(zone.Id, networkUsers.get(zone.NetworkId));
        }

        for (brIdeaSubscription__c subscr : subscrs) {

            if (emailsMap.get(subscr.Idea__c) != NULL) {
                emailsMap.get(subscr.Idea__c).add(subscr.User__r.Email);
            } else {
                emailsMap.put(subscr.Idea__c, new List<String>{subscr.User__r.Email});
            }
        }

        return emailsMap;
    }
}