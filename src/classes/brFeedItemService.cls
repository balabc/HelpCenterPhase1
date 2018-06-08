public with sharing class brFeedItemService {

    /**
     * Returns count feed items
     *
     * {@inheritDoc}
     *
     * @return      count feed items
     * @see         Integer
     */
    public static Integer getFeedItemCount() {
        brSecurityService.performAccessCheck('read', 'FeedItem', new List<String>{'NetworkScope','BestCommentId','Type','Visibility'});

        return brFeedItemServiceSelector.getQuestionBestComment(10000);
    }

    /**
     * Returns questions
     *
     * {@inheritDoc}
     *
     * @return      list questions as brFeedItemModel
     * @see         List<brFeedItemModel>
     */
    public static List<brFeedItemModel> getQuestions() {
        brSecurityService.performAccessCheck('read', 'FeedItem', new List<String>{'Title','CreatedDate','NetworkScope','Type','Visibility'});

        List<brFeedItemModel> items = new List<brFeedItemModel>();

        List<SObject> topicQuestions = brFeedItemServiceSelector.getQuestion(4);
        for (SObject question : topicQuestions) {
            brFeedItemModel cls = new brFeedItemModel();
            cls.id = String.valueOf(question.get('Id'));
            cls.name = String.valueOf(question.get('Title'));
            items.add(cls);
        }

        return items;

    }

}