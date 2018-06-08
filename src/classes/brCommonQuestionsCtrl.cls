
public with sharing class brCommonQuestionsCtrl {

    @AuraEnabled
    public static List<Public__kav> getArticles () {
        brSecurityService.performAccessCheck('read', 'Public__kav', new List<String>{'ArticleTotalViewCount','Title','UrlName'});

        List<Public__kav> kArticles = [SELECT Title, UrlName FROM Public__kav WHERE PublishStatus = 'Online' ORDER BY ArticleTotalViewCount DESC LIMIT 8];
        return kArticles;
    }

}