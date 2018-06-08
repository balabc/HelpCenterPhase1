({
    getUserInfo: function(component) {
        var action = component.get('c.getUserInfo'),
            currentId = component.get('v.curId');

        if (!$A.util.isUndefinedOrNull(currentId) && !$A.util.isEmpty(currentId)) {
            action.setParams({
                'userId': currentId
            });
        }

        action.setStorable();

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var user = response.getReturnValue();
                component.set("v.user", user);
            } else if (state === "ERROR") {
                var errors = response.getError();
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
        });
        $A.enqueueAction(action);
    },
    changeLocation: function(component, type, data) {
        var urlEvent;

        switch (type) {
            case 'ExternalLink': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToURL');
                    urlEvent.setParams({
                        'url': data
                    });
                    urlEvent.fire();
                }
                break;
            }
            case 'InternalLink': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToURL');
                    urlEvent.setParams({
                        'url': data
                    });
                    urlEvent.fire();
                }
                break;
            }
            case 'SalesforceObject': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToSObject');
                    urlEvent.setParams({
                        'recordId': data
                    });
                    urlEvent.fire();
                }
                break;
            }
        }
    }
})