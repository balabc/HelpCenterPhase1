({
    hasVotingCurrentUser: function (cmp, event) {
        var action = cmp.get('c.hasVoteForArticle');

        action.setParams({"articleId" : cmp.get('v.articleId')});

        action.setCallback(this, function (response) {
            var state = response.getState(),
                hasVoting = response.getReturnValue();

            if (state === 'SUCCESS') {
                if (hasVoting) {
                    cmp.set('v.feedbackMessage', "Thanks for your feedback!");
                }
            } else if (state === "ERROR") {
                console.error('callback error: hasVotingCurrentUser in brArticleFeedbackHelper.js');
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

        action.setCallback(this, function (response) {
            var state = response.getState(),
                reasons = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.reasons', reasons);
            } else if (state === "ERROR") {
                console.log('callback error: getReasons in brArticleFeedbackHelper.js');
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
    addVoteUp: function (cmp, event) {
        var action = cmp.get('c.addVoteUpForArticle');

        action.setParams({"articleId" : cmp.get('v.articleId')});

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === 'SUCCESS') {
               cmp.set('v.feedbackMessage', "Thanks for your feedback!");
            } else if (state === "ERROR") {
                console.log('callback error: addVoteUp in brArticleFeedbackHelper.js');
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
    addVoteDownAndReason: function (cmp, event) {
        var action = cmp.get('c.addVoteDownAndSaveReasonForArticle'),
            reason = cmp.find('reason').get("v.value");

        action.setParams({
            "articleId": cmp.get('v.articleId'),
            "reason": reason
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === 'SUCCESS') {
                cmp.set('v.feedbackMessage', "Thanks for your feedback!");
            } else if (state === "ERROR") {
                console.log('callback error: addVoteUp in brArticleFeedbackHelper.js');
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
    getTypeForCurrentUser: function (cmp, event) {
        var action = cmp.get('c.getUserType');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                type = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.userType', type);
            } else if (state === "ERROR") {
                console.log('callback error: getUserType in brUserMenu.js');
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
    }
})