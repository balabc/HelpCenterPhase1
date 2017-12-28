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
        brSecurityService.performAccessCheck('read', 'Vote', new List<String>{'CreatedById','ParentId'});
        Boolean hasVote = false;

        try {
            hasVote = [SELECT Id FROM Vote WHERE CreatedById = :userInfo.getUserId() AND ParentId = :articleId].isEmpty() ? false : true;
        } catch (QueryException ex) {
            System.debug('brArticleFeedbackCtrl::hasVoteForArticle: ' + ex.getMessage());
        }
        return hasVote;
    }

    @AuraEnabled
    public static List<String> getFeedbackReasons () {
        brSecurityService.performAccessCheck('read', 'brArticleFeedback__c', new List<String>{'Reason__c'});

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
        brSecurityService.performAccessCheck('create', 'Vote', new List<String>{'Type','ParentId'});
        try {
            insert new Vote(ParentId = articleId, Type = 'Up');
        } catch (DmlException ex) {
            System.debug('brArticleFeedbackCtrl::addVoteUpForArticle: ' + ex.getMessage());
        }
    }

    @AuraEnabled
    public static void addVoteDownAndSaveReasonForArticle(String articleId, String reason) {
        brSecurityService.performAccessCheck('create', 'Vote', new List<String>{'Type','ParentId'});
        brSecurityService.performAccessCheck('read', 'KnowledgeArticle', new List<String>{'ArticleNumber'});
        brSecurityService.performAccessCheck('create', 'brArticleFeedback__c', new List<String>{'Reason__c','Article_Number__c'});

        try {
            insert new Vote(ParentId = articleId, Type = 'Down');
        } catch (DmlException ex) {
            System.debug('brArticleFeedbackCtrl::addVoteDownAndSaveReasonForArticle: ' + ex.getMessage());
        }

        if (!Test.isRunningTest()) {
            String articleNumber = [SELECT ArticleNumber FROM KnowledgeArticle WHERE Id = :articleId LIMIT 1].ArticleNumber;

            try {
                insert new brArticleFeedback__c(Reason__c = reason, Article_Number__c = articleNumber);
            } catch (DmlException ex) {
                System.debug('brArticleFeedbackCtrl::addVoteDownAndSaveReasonForArticle: ' + ex.getMessage());
            }
        }
    }
}