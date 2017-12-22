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
        List<brBlogArticleWrapper> articleWrappers  = new List<brBlogArticleWrapper>();
        List<brBlog_article__c> articles = [SELECT id, Name FROM brBlog_article__c WHERE Published__c = true ORDER BY Published_Date__c DESC limit 4];
        for(brBlog_article__c art : articles) {
            brBlogArticleWrapper cls = new brBlogArticleWrapper();
            cls.item = art;
            articleWrappers.add(cls);
        }
        return articleWrappers;
    }
    @AuraEnabled
    public static List<FeedItem> getGroupPosts(String id) {
        return [SELECT Id, Body FROM FeedItem
                                WHERE ParentId = :id
                                ORDER BY CreatedDate
                                DESC LIMIT 4];
    }
}