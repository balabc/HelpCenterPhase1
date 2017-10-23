({
    doInit: function(component) {
        component.set('v.routeInput', {recordId: component.get('v.articleId')});
    },

    openArticle: function(component) {

        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get('v.articleId')
        });
        navEvt.fire();
    }
})