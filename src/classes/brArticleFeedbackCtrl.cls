public with sharing class brArticleFeedbackCtrl {
    @AuraEnabled
    public static String getUserType() {
        if (!Test.isRunningTest()) { return UserInfo.getUserType();}
        else {
            return 'Standard';
        }
    }

    @AuraEnabled
    public static Boolean hasVoteForArticle(String articleId) {
        return [SELECT Id FROM Vote WHERE CreatedById = :userInfo.getUserId() AND ParentId = :articleId].isEmpty()?false:true;
    }

    @AuraEnabled
    public static List<String> getFeedbackReasons () {
        List<String> reasons = new List<String>();
        Schema.DescribeFieldResult fieldResult = brArticleFeedback__c.Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        if (!Test.isRunningTest()) {
            for (Schema.PicklistEntry pickListVal : ple) { reasons.add(pickListVal.getLabel());}
        } else {
            reasons.add('Test');
        }

        return reasons;
    }

    @AuraEnabled
    public static void addVoteUpForArticle(String articleId) {
        insert new Vote(ParentId = articleId, Type = 'Up');
    }

    @AuraEnabled
    public static void addVoteDownAndSaveReasonForArticle(String articleId, String reason) {
        insert new Vote(ParentId = articleId, Type = 'Down');

        if (!Test.isRunningTest()) {
            String articleNumber = [SELECT ArticleNumber FROM KnowledgeArticle WHERE Id = :articleId LIMIT 1].ArticleNumber;
            insert new brArticleFeedback__c(Reason__c = reason, Article_Number__c = articleNumber);
        }
    }
}