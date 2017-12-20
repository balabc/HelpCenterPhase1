({
    doInit : function(component) {
        var objSfdcSite = $A.get('$SfdcSite'),
            objSfdcSite = (!!objSfdcSite? objSfdcSite.pathPrefix: ''),
            categoriesCount = component.get('v.categoriesCount'),
            item = component.get('v.guideArticle');
        component.set('v.routeInput', {recordId: objSfdcSite + '/s/article/' + component.get('v.guideArticle').First_Chapter_Url__c});
        //console.log(categoriesCount);
        component.set('v.countChapters', categoriesCount[item.Id]);
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