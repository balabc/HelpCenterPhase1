public class brIdeaCommentTriggerHandler {

    public brIdeaCommentTriggerHandler(){
        if (!Trigger.isExecuting) throw new brIdeaSecurityException('This code must run in trigger context only');
    }

    public void sendNotificationsToSubscribers(List<IdeaComment> ideaCommentsList){
        Set<String> ideasSet = new Set<String>();
        brEmailNotification notificator = new brEmailNotification();

        for(IdeaComment ic : ideaCommentsList) {
            ideasSet.add(ic.IdeaId);
        }

        Map<String, List<String>> ideasEmails = brIdeaDataSelector.getSubscribersEmailsByIdeas(ideasSet, false);

        List<IdeaComment> comments = [SELECT IdeaId, CreatedById, CommentBody, Idea.Title, Idea.CommunityId
                                        FROM IdeaComment WHERE Id IN :ideaCommentsList];

        for (IdeaComment comment : comments) {
            if (ideasEmails.get(comment.IdeaId) == NULL) continue;

            for (String usrEmail : ideasEmails.get(comment.IdeaId)) {
                notificator.addNewCommentNotification1(usrEmail, comment, 'NewCommentNotificationToSubscriber');
            }
        }

        notificator.sendEmails();
    }


    public void sendNotificationsToAssignedUsers(List<IdeaComment> ideaCommentsList){
        brEmailNotification notificator = new brEmailNotification();
        Map<String, List<String>> aMap = brIdeaDataSelector.getAssignedUserEmailsByCategory();
        List<String> categories;
        Set<String> emailsList;

        List<IdeaComment> comments = [SELECT CommentBody, Idea.CommunityId, Idea.Title, Idea.Categories
                                        FROM IdeaComment WHERE Id IN :ideaCommentsList];

        for (IdeaComment comment : comments) {
            categories = comment.Idea.Categories.split(';');
            emailsList = new Set<String>();

            for (String category : categories) {
                if (aMap.get(category) == NULL) continue;

                emailsList.addAll(aMap.get(category));
            }

            for (String em : emailsList) {
                notificator.addNewCommentNotification1(em, comment, 'NewCommentNotificationToCategoryAssignee');
            }
        }

        notificator.sendEmails();
    }
}