
({
    getArticles: function(component) {
        try {
            var action = component.get("c.getArticles");
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var articlesList = response.getReturnValue();
                    component.set("v.articlesList", articlesList);
                    component.set("v.articlesCount", articlesList.length);
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                        }
                    } else if (state === "ERROR") {
                        errors = response.getError();
                        var error_msg = '';
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                if (errors[0].message === 'access_error') {
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
                }
            });
            $A.enqueueAction(action);

        }catch(e){
        }

    }
})