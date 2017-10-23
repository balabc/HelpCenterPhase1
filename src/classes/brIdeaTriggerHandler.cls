public class brIdeaTriggerHandler {

    public brIdeaTriggerHandler(){
        if (!Trigger.isExecuting) throw new brIdeaSecurityException('This code must run in trigger context only');
    }

    public void createSubscriptions(List<Idea> ideaList) {
        List<brIdeaSubscription__c> subscrList = new List<brIdeaSubscription__c>();

        for (Idea idea : ideaList) {
            subscrList.add(new brIdeaSubscription__c(
                    Idea__c = idea.Id,
                    User__c = idea.CreatedById,
                    Token__c = brUtils.generateToken(50)
                ));
        }

        insert subscrList;
    }

    public void sendNewIdeaNotifications(List<Idea> ideasList) {
        Map<String, List<String>> aMap = brIdeaDataSelector.getAssignedUserEmailsByCategory();
        brEmailNotification notificator = new brEmailNotification();
        List<String> categories;
        Set<String> emailsList;

        for (Idea idea : ideasList) {
            categories = idea.Categories.split(';');
            emailsList = new Set<String>();

            for (String category : categories) {
                if (aMap.get(category) == NULL) continue;

                emailsList.addAll(aMap.get(category));
            }

            for (String em : emailsList) {
                notificator.addIdeaCreatedNotification(em, idea, 'NewIdeaNotificationToCategoryAssignee');
            }
        }

        notificator.sendEmails();
    }

    public void sendStatusChangeNotifications(List<Idea> ideasList, Map<Id, Idea> oldMap) {

        List<Idea> filteredList = new List<Idea>();

        for (Idea idea : ideasList) {
            if(idea.Status != oldMap.get(idea.Id).Status) {
                filteredList.add(idea);
            }
        }

        if (filteredList.isEmpty()) return;

        this.sendStatusChangeNotificationsToSubscribers(filteredList, oldMap);
        this.sendStatusChangeNotificationsToManagers(filteredList, oldMap);
    }

    private void sendStatusChangeNotificationsToSubscribers(List<Idea> ideasList, Map<Id, Idea> oldMap){
        brEmailNotification notificator = new brEmailNotification();
        String oldStatus;
        List<brIdeaSubscription__c> subscriptions = [
                SELECT Idea__c, Idea__r.Id, Idea__r.Title, Idea__r.Status,
                        Idea__r.CommunityId, Idea__r.Body, User__r.Email
                FROM brIdeaSubscription__c
                WHERE Idea__c IN :ideasList LIMIT 10000];

        for (brIdeaSubscription__c subscr : subscriptions) {
            if (subscr.User__r.Email != null) {
                oldStatus = oldMap.get(subscr.Idea__c).Status != NULL ? oldMap.get(subscr.Idea__c).Status : '';
                notificator.addStatusChangeNotification1(subscr.User__r.Email, (Idea)subscr.Idea__r,
                        oldStatus, 'ChangeStatusNotificationToSubscriber');
            }
        }

        notificator.sendEmails();
    }

    private void sendStatusChangeNotificationsToManagers(List<Idea> ideasList, Map<Id, Idea> oldMap){
        Map<String, List<String>> aMap = brIdeaDataSelector.getAssignedUserEmailsByCategory();
        brEmailNotification notificator = new brEmailNotification();
        List<String> categories;
        Set<String> emailsList;
        String oldStatus;

        for (Idea idea : ideasList) {
            categories = idea.Categories.split(';');
            emailsList = new Set<String>();

            for (String category : categories) {
                if (aMap.get(category) == NULL) continue;

                emailsList.addAll(aMap.get(category));
            }

            for (String em : emailsList) {
                oldStatus = oldMap.get(idea.Id).Status != NULL ? oldMap.get(idea.Id).Status : '';
                notificator.addStatusChangeNotification1(em, idea, oldStatus, 'ChangeStatusNotificationToCategoryAssignee');
            }
        }

        notificator.sendEmails();
    }

}