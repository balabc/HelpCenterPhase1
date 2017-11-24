public with sharing class brFeaturedArticlesCtrl {

    @AuraEnabled
    public static List<Public__kav> getArticles () {
        List<Public__kav> kArticles = [SELECT ArticleNumber,ArticleTotalViewCount,Id,KnowledgeArticleId,Title,UrlName FROM Public__kav WHERE IsLatestVersion = true AND PublishStatus = 'Online' AND IsVisibleInPkb = true ORDER BY ArticleTotalViewCount DESC LIMIT 8];
        return kArticles;
    }
}