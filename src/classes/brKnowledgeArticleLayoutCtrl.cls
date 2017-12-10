public with sharing class brKnowledgeArticleLayoutCtrl {

    @AuraEnabled
    public static String getArticleTypeByUrlName(String urlName) {
        Id articleId = [SELECT Id FROM KnowledgeArticleVersion WHERE UrlName = :urlName LIMIT 1].Id;

        return String.valueOf(articleId.getsObjectType());
    }
}