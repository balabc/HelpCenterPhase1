({
    doInit : function(cmp) {
        cmp.set('v.routeInput', {recordId: cmp.get('v.guideArticle').First_Chapter_Url__c});
    },

    onClick : function(cmp) {
        var navEvt = $A.get("e.force:navigateToURL");
        var url = cmp.get('v.guideArticle').First_Chapter_Url__c;
        url = '/article/' + url;
        navEvt.setParams({
            "url": url
        });
        navEvt.fire();
    }
})