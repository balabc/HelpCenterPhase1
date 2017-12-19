({
    getCountForEachCategory : function(component) {
        var action = component.get('c.getCountForEachCategory');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                categoriesCount = response.getReturnValue();

            if (state === 'SUCCESS') {
                component.set('v.categoriesCount', categoriesCount);
                this.getGuideArticles(component);
            }
        });

        $A.enqueueAction(action);
    },
    getGuideArticles : function(component) {
        var action = component.get('c.getGuideArticles');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                guideArticles = response.getReturnValue();

            if (state === 'SUCCESS') {
                component.set('v.guideArticles', guideArticles);
            } else {
                console.log('callback error: doInit in brGuidesListController.js');
            }
        });

        $A.enqueueAction(action);
    }
})