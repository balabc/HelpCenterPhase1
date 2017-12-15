({
    doInit : function(cmp) {
        cmp.set('v.routeInput', {recordId: cmp.get('v.guideArticle').First_Chapter_Url__c});
    },

    onClick : function(cmp) {
        var navEvt = $A.get("e.force:navigateToURL");
        navEvt.setParams({
            "url": cmp.get('v.guideArticle').First_Chapter_Url__c
        });
        navEvt.fire();
    }
})