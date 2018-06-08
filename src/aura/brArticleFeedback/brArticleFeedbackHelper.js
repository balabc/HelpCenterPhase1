({
    onRender: function (cmp, event) {
        if (document.cookie.split(';').filter(function(item) {
                return item.indexOf('PKB2SessionId') >= 0
            }).length) {
            this.hasVotingForCurrentUser(cmp);
        } else {
            var url = Math.random().toString(36).substr(2, 8) + '-' + Math.random().toString(36).substr(2, 4)
                + '-' + Math.random().toString(36).substr(2, 4) + '-' + Math.random().toString(36).substr(2, 4)
                + '-' + Math.random().toString(36).substr(2, 12);

            document.cookie = "PKB2SessionId=" + url;
            cmp.set('v.showVoting', true);
        }
    },
    hasVotingForCurrentUser: function (cmp, event) {
        var action = cmp.get('c.hasVoteForArticle'),
            sessionId = this.getSessionId(cmp);

        action.setParams({
            "sessionId": sessionId,
            "articleId": cmp.get('v.article.KnowledgeArticleId')
        });

        action.setCallback(this, function (response) {
            var state = response.getState(),
                hasVoting = response.getReturnValue();

            if (state === 'SUCCESS') {
                if (hasVoting) {
                    cmp.set('v.feedbackMessage', "Thanks for your feedback!");
                } else {
                    cmp.set('v.showVoting', true);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message === 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },
    getReasons: function (cmp, event) {
        var action = cmp.get('c.getFeedbackReasons');

        action.setStorable();

        action.setCallback(this, function (response) {
            var state = response.getState(),
                reasons = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.reasons', reasons);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message === 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },
    addPositiveFeedBack: function (cmp, event) {
        var sessionId = this.getSessionId(cmp),
            action = cmp.get('c.addPositiveFeedBackForArticle');

        var articleFields = {
            "articleId": cmp.get('v.article.KnowledgeArticleId'),
            "articleTitle": cmp.get('v.article.Title'),
            "articleNumber": cmp.get('v.article.ArticleNumber'),
            "author": cmp.get('v.article.Author__c'),
            "articleCreatedById": cmp.get('v.article.ArticleCreatedById'),
            "lastPublishedDate": cmp.get('v.article.LastPublishedDate').toString(),
            "lastModifiedById": cmp.get('v.article.LastModifiedById').toString(),
            "isVisibleInApp": cmp.get('v.article.IsVisibleInApp').toString(),
            "isVisibleInPkb": cmp.get('v.article.IsVisibleInPkb').toString(),
            "articleCaseAttachCount": cmp.get('v.article.ArticleCaseAttachCount').toString()
        };

        action.setParams({
            "articleFields": articleFields,
            "sessionId": sessionId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === 'SUCCESS') {
                cmp.set('v.feedbackMessage', "Thanks for your feedback!");
                cmp.set('v.showVoting', false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message === 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },
    addNegativeFeedback: function (cmp, event) {
        var action = cmp.get('c.addNegativeFeedbackForArticle'),
            reason = cmp.find('reason').get("v.value"),
            sessionId = this.getSessionId(cmp);

        var articleFields = {
            "articleId": cmp.get('v.article.KnowledgeArticleId'),
            "articleTitle": cmp.get('v.article.Title'),
            "articleNumber": cmp.get('v.article.ArticleNumber'),
            "author": cmp.get('v.article.Author__c'),
            "articleCreatedById": cmp.get('v.article.ArticleCreatedById'),
            "lastPublishedDate": cmp.get('v.article.LastPublishedDate').toString(),
            "lastModifiedById": cmp.get('v.article.LastModifiedById').toString(),
            "isVisibleInApp": cmp.get('v.article.IsVisibleInApp').toString(),
            "isVisibleInPkb": cmp.get('v.article.IsVisibleInPkb').toString(),
            "articleCaseAttachCount": cmp.get('v.article.ArticleCaseAttachCount').toString()
        };

        action.setParams({
            "articleFields": articleFields,
            "sessionId": sessionId,
            "feedbackComment": cmp.get('v.comment'),
            "notHelpfulOption": reason
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === 'SUCCESS') {
                cmp.set('v.feedbackMessage', "Thanks for your feedback!");
                cmp.set('v.showVoting', false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message === 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },
    getSessionId: function (cmp, event) {
        var match = document.cookie.match(new RegExp('PKB2SessionId' + '=([^;]+)'));
        if (match) {
            return match[1];
        }
    }
})