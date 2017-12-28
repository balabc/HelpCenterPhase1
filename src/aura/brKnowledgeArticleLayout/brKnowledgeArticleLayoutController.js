({
    doInit: function(cmp) {
        var action = cmp.get('c.getArticleTypeByUrlName'),
            pathArray = window.location.pathname.split( '/' );

        action.setParams({
            urlName: pathArray.pop()
        });

        action.setCallback(this, function (response) {
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === 'SUCCESS') {
                if(resVal === 'Public__kav' || resVal === 'Learning__kav' || resVal === 'University__kav') {
                    cmp.set('v.articleType', resVal);
                    cmp.set('v.isKnowledgeBaseArticle', true);
                }
                cmp.set('v.isContentVisible', true);
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
    }
})