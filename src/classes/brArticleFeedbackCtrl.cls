/**
 * This class is controller for brArticleFeedback aura component
 */
public with sharing class brArticleFeedbackCtrl {
    /**
     *
     *
     * @param sessionId session id
     *
     * @return the existence of record for the current session or not
     */
    @AuraEnabled
    public static Boolean hasVoteForArticle(String sessionId) {
        brSecurityService.performAccessCheck('read', 'PKB_Article_Feedback_Deflection__c', new List<String>{'Id','Session_ID__c'});
        Boolean hasArticleWithCurrentSession = false;

        try {
            hasArticleWithCurrentSession = [SELECT Id
                                            FROM PKB_Article_Feedback_Deflection__c
                                            WHERE Session_ID__c = :sessionId].isEmpty() ? false : true;
        } catch (QueryException ex) {
            System.debug(ex.getMessage());
        }
        return hasArticleWithCurrentSession;
    }

    /**
     *
     *
     * @return feedback reasons
     */
    @AuraEnabled
    public static List<String> getFeedbackReasons () {
        brSecurityService.performAccessCheck('read', 'PKB_Article_Feedback_Deflection__c', new List<String>{'Why_Not_Helpful__c'});

        List<String> reasons = new List<String>();
        Schema.DescribeFieldResult fieldResult = PKB_Article_Feedback_Deflection__c.Why_Not_Helpful__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        if (!Test.isRunningTest()) {
            for (Schema.PicklistEntry pickListVal : ple) { reasons.add(pickListVal.getLabel());}
        } else {
            reasons.add('Test');
        }

        return reasons;
    }

    /**
     *
     * insert article feedback deflection
     *
     * @param articleFields article fields
     * @param sessionId session id
     */
    @AuraEnabled
    public static void addPositiveFeedBackForArticle(Map<String,String> articleFields, String sessionId) {
        brSecurityService.performAccessCheck('create', 'PKB_Article_Feedback_Deflection__c',
        new List<String>{'Author__c','Article_ID__c','Article_Number__c','Article_Title__c',
                    'ArticleCreatedBy__c','Last_Published_Date__c','ArticleLastModifiedBy__c',
                    'VisibleInInternalApp__c','VisibleInPublicKnowledgebase__c',
                    'Case_Association_Count__c','Session_ID__c'});


        try {
            PKB_Article_Feedback_Deflection__c afd = new PKB_Article_Feedback_Deflection__c(
                    Author__c = articleFields.get('author'),
                    Article_ID__c = articleFields.get('articleId'),
                    Article_Number__c = articleFields.get('articleNumber'),
                    Article_Title__c = articleFields.get('articleTitle'),
                    ArticleCreatedBy__c = articleFields.get('articleCreatedById'),
                    Last_Published_Date__c = (DateTime)json.deserialize('"' + articleFields.get('lastPublishedDate') + '"', datetime.class),
                    ArticleLastModifiedBy__c = articleFields.get('lastModifiedById'),
                    VisibleInInternalApp__c = Boolean.valueOf(articleFields.get('isVisibleInApp')),
                    VisibleInPublicKnowledgebase__c = Boolean.valueOf(articleFields.get('isVisibleInPkb')),
                    Case_Association_Count__c = Decimal.valueOf(articleFields.get('articleCaseAttachCount')),
                    Session_ID__c = sessionId
            );
            insert afd;
        } catch (DmlException ex) {
            System.debug(ex.getMessage());
        }
    }

    /**
     *
     * insert article feedback deflection with reason
     *
     * @param articleFields article fields
     * @param sessionId session id
     * @param feedbackComment feedback comment when option is Other (please specify)
     * @param notHelpfulOption current option for feedback
     */
    @AuraEnabled
    public static void addNegativeFeedbackForArticle(Map<String,String> articleFields, String feedbackComment, String notHelpfulOption, String sessionId) {
        brSecurityService.performAccessCheck('create', 'PKB_Article_Feedback_Deflection__c',
        new List<String>{'Author__c','Article_ID__c','Article_Number__c','Article_Title__c',
                    'ArticleCreatedBy__c','Last_Published_Date__c','ArticleLastModifiedBy__c',
                    'VisibleInInternalApp__c','VisibleInPublicKnowledgebase__c',
                    'Case_Association_Count__c','Session_ID__c','Comments__c', 'Why_Not_Helpful__c'});

        try {
            PKB_Article_Feedback_Deflection__c afd = new PKB_Article_Feedback_Deflection__c(
                    Author__c = articleFields.get('author'),
                    Article_ID__c = articleFields.get('articleId'),
                    Article_Number__c = articleFields.get('articleNumber'),
                    Article_Title__c = articleFields.get('articleTitle'),
                    ArticleCreatedBy__c = articleFields.get('articleCreatedById'),
                    Last_Published_Date__c = (DateTime)json.deserialize('"' + articleFields.get('lastPublishedDate') + '"', datetime.class),
                    ArticleLastModifiedBy__c = articleFields.get('lastModifiedById'),
                    VisibleInInternalApp__c = Boolean.valueOf(articleFields.get('isVisibleInApp')),
                    VisibleInPublicKnowledgebase__c = Boolean.valueOf(articleFields.get('isVisibleInPkb')),
                    Case_Association_Count__c = Decimal.valueOf(articleFields.get('articleCaseAttachCount')),
                    Session_ID__c = sessionId,
                    Comments__c = feedbackComment,
                    Why_Not_Helpful__c = notHelpfulOption
            );
            insert afd;
        } catch (DmlException ex) {
            System.debug(ex.getMessage());
        }
    }
}