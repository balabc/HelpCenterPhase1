({
    doInit : function(component, event, helper) {
        var art = component.get('v.article'),
            selectedArticleId = component.get('v.selectedArticleId');
        if (!!art) {
            component.set('v.routeInput', {
                recordId: art.article_id
            });

            if(art.article_id === selectedArticleId) {
                helper.retrieveArticleSections(component, art.article_id);
            }
        }
    },

    clickElement: function(component, event, helper) {
        var toggleEvent = component.getEvent("brCategoriesToggleEventHandler"),
            art = component.get('v.article');
        if (!!art) {
            helper.retrieveArticleSections(component, art.article_id);
            toggleEvent.setParams({
                "idRow": 'brCategoriesArticles_' + component.get('v.article').id
            });
            toggleEvent.fire();
        }
    }
})