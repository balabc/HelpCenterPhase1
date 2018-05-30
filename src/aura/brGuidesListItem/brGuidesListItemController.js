({
    doInit : function(component) {
        var objSfdcSiteValue = $A.get('$SfdcSite'),
            objSfdcSite = (!$A.util.isUndefinedOrNull(objSfdcSiteValue)? objSfdcSiteValue.pathPrefix: ''),
            categoriesCount = component.get('v.categoriesCount'),
            item = component.get('v.guideArticle');
        component.set('v.routeInput', {recordId: objSfdcSite + '/s/article/' + component.get('v.guideArticle').First_Chapter_Url__c});
        component.set('v.countChapters', categoriesCount[item.Id]);
    },

    onClick : function(component, event) {
        var navEvt = $A.get("e.force:navigateToURL"),
            targetUrl = event.target.dataset.url;
        navEvt.setParams({
            "url": targetUrl
        });
        navEvt.fire();
    }
})