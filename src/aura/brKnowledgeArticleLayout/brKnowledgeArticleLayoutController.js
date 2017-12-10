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
            }
        });

        $A.enqueueAction(action);
    }
})