({
    onClick : function(cmp, event, helper) {
        var articleId = cmp.get('v.videoArticleForCurrentPage').Id;
        cmp.set('v.routeInput', {recordId: articleId});

        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": articleId
        });
        navEvt.fire();
    }

})