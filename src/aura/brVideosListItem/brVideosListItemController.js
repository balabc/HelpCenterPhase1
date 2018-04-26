({
    doInit : function(component) {
        var objSfdcSite = $A.get('$SfdcSite');

        objSfdcSite = (!!objSfdcSite ? objSfdcSite.pathPrefix : '');
        component.set('v.routeInput', {recordId: objSfdcSite + '/s/article/' + component.get('v.videoArticleForCurrentPage').UrlName});
    },

    onClick : function(cmp) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get('v.videoArticleForCurrentPage').Id
        });
        navEvt.fire();
    }

})