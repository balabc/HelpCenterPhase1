
public with sharing class brCommonQuestionsCtrl {

    @AuraEnabled
    public static List<Public__kav> getArticles () {
        brSecurityService.performAccessCheck('read', 'Public__kav', new List<String>{
            'ArticleNumber','ArticleTotalViewCount','KnowledgeArticleId','Title','UrlName','IsLatestVersion',
            'PublishStatus','IsVisibleInPkb'});

        List<Public__kav> kArticles = [SELECT ArticleNumber,ArticleTotalViewCount,Id,KnowledgeArticleId,Title,UrlName FROM Public__kav WHERE IsLatestVersion = true AND PublishStatus = 'Online' AND IsVisibleInPkb = true ORDER BY ArticleTotalViewCount DESC LIMIT 8];
        return kArticles;
    }

}