({
    doInit : function(cmp) {
        cmp.set('v.routeInput', {recordId: cmp.get('v.videoArticleForCurrentPage').Id});
    },

    onClick : function(cmp) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get('v.videoArticleForCurrentPage').Id
        });
        navEvt.fire();
    }

})