/**
 * This class is controller for brFeaturedArticles aura component
 */
public with sharing class brFeaturedArticlesCtrl {
    /**
     * Returns list featured articles which should be showing in brFeaturedArticles aura component
     *
     * @param countArticles the count of featured articles which was taken from aura attribute
     *
     * @return list featured articles limited by number of articles
     */

    @AuraEnabled
    public static List<Public__kav> getArticles(Integer countArticles) {
        List<Public__kav> kArticles = [ SELECT ArticleNumber,ArticleTotalViewCount,Id,KnowledgeArticleId,Title,UrlName
                                        FROM Public__kav
                                        WHERE IsLatestVersion = true AND PublishStatus = 'Online' AND IsVisibleInPkb = true
                                        ORDER BY ArticleTotalViewCount DESC
                                        LIMIT :Integer.valueOf(countArticles)];
        return kArticles;
    }
}