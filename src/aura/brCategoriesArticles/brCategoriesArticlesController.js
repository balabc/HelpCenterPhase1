({
    doInit : function(component, event, helper) {
        var art = component.get('v.article');
        if (!!art) {
            component.set('v.routeInput', {
                recordId: art.article_id
            });
        }
    },
    clickElement: function(component, event, helper) {
        var toggleEvent = component.getEvent("brCategoriesToggleEventHandler"),
            art = component.get('v.article');
        if (!!art) {
            toggleEvent.setParams({
                "idRow": 'brCategoriesArticles_' + component.get('v.article').id
            });
            toggleEvent.fire();
        }
    }
})