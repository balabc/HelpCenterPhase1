({
    doInit : function(component) {
        component.set('v.routeInput', {recordId: $A.get('$SfdcSite').pathPrefix + '/s/article/' + component.get('v.guideArticle').First_Chapter_Url__c});
        console.log($A.get('$SfdcSite'));
    },

    onClick : function(component, event) {
        var navEvt = $A.get("e.force:navigateToURL"),
            targetUrl = event.target.dataset.url;
        //url = component.get('v.guideArticle').First_Chapter_Url__c;
        navEvt.setParams({
            "url": targetUrl
        });
        navEvt.fire();
    }
})