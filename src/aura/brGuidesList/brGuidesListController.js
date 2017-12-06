({
    doInit: function (cmp, event, helper) {
        var action = cmp.get('c.getGuideArticles');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                guideArticles = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.guideArticles', guideArticles);
            } else {
                console.log('callback error: doInit in brGuidesListController.js');
            }
        });

        $A.enqueueAction(action);
    },
})