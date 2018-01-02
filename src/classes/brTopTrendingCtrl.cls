public with sharing class brTopTrendingCtrl {

    /**
     * Returns id chatter group list
     *
     * {@inheritDoc}
     *
     * @return      id chatter group list
     * @see         Id
     */
    @AuraEnabled
    public static Id getChatterGroupListId() {
        return brChatterGroupService.getListId();
    }

    /**
     * Returns chatter group what exist in ids
     *
     * {@inheritDoc}
     *
     * @param       ids    String
     * @return      list chatter group
     * @see         List<brChatterGroupModel>
     */
    @AuraEnabled
    public static List<brChatterGroupModel> getChatterGroupByStringId(String ids) {
        return brChatterGroupService.getChatterGroupByStringId(ids);
    }

    /**
     * Returns questions
     *
     * {@inheritDoc}
     *
     * @return      list questions
     * @see         List<brFeedItemModel>
     */
    @AuraEnabled
    public static List<brFeedItemModel> getQuestions() {
        return brFeedItemService.getQuestions();
    }

    /**
     * Returns article in blog
     *
     * {@inheritDoc}
     *
     * @return      list article
     * @see         List<brBlogArticleWrapper>
     */
    @AuraEnabled
    public static List<brBlogArticleWrapper> getBlogArticles() {
        brSecurityService.performAccessCheck('read', 'brBlog_article__c', new List<String>{'Published__c','Name','Published_Date__c'});

        try {
            List<brBlogArticleWrapper> articleWrappers = new List<brBlogArticleWrapper>();
            List<brBlog_article__c> articles = [SELECT id, Name FROM brBlog_article__c WHERE Published__c = true ORDER BY Published_Date__c DESC limit 4];
            for (brBlog_article__c art : articles) {
                brBlogArticleWrapper cls = new brBlogArticleWrapper();
                cls.item = art;
                articleWrappers.add(cls);
            }
            return articleWrappers;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static List<brFeedItemModel> getGroupPosts(String id) {
        brSecurityService.performAccessCheck('read', 'FeedItem', new List<String>{'ParentId','CreatedDate','Type','Visibility','Body'});
        List<brFeedItemModel> feedItemModels = new List<brFeedItemModel>();
        Pattern titlePattern = Pattern.compile('<b>(.*?)</b>');

        try {
            for (FeedItem feedItem: [SELECT Id, Body FROM FeedItem
                                        WHERE ParentId = :id AND Type='TextPost' AND Visibility = 'AllUsers'
                                        ORDER BY CreatedDate DESC LIMIT 4]) {

                Matcher m;
                m = titlePattern.matcher(feedItem.Body);

                if (m.find()) {
                    brFeedItemModel feedItemModel = new brFeedItemModel();
                    feedItemModel.id = feedItem.Id;
                    feedItemModel.name = m.group(1);
                    feedItemModels.add(feedItemModel);
                }
            }
            return feedItemModels;

        } catch (Exception e) { System.debug(e.getMessage()); return null; }
    }
}