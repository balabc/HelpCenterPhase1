({
    getCountForEachCategory : function(component) {
        var action = component.get('c.getCountForEachCategory');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                categoriesCount = response.getReturnValue();

            if (state === 'SUCCESS') {
                component.set('v.categoriesCount', categoriesCount);
                //console.log(categoriesCount);
                this.getGuideArticles(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message == 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
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
                //console.log(guideArticles);
                component.set('v.guideArticles', guideArticles);
            } else if (state === "ERROR") {
                //console.log('callback error: doInit in brGuidesListController.js');
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message == 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    }
})