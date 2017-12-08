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
            } else {
                console.log('callback error: hasVotingCurrentUser in brArticleFeedbackHelper.js');
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
            } else {
                console.log('callback error: getReasons in brArticleFeedbackHelper.js');
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
            } else {
                console.log('callback error: addVoteUp in brArticleFeedbackHelper.js');
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
            } else {
                console.log('callback error: addVoteUp in brArticleFeedbackHelper.js');
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
            } else {
                console.log('callback error: getUserType in brUserMenu.js');
            }
        });

        $A.enqueueAction(action);
    }
})