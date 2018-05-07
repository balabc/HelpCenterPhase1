({
	getData : function(component, outVar, method, params) {
        var action = component.get(method);
        if (params !== false)
        	action.setParams(params);

        action.setStorable();

        action.setCallback(this, function(response) {
            var state = response.getState(),
                data;
            if (state === "SUCCESS") {
                data = response.getReturnValue();
               //console.log(method, data);
                component.set(outVar, data);
            }
        });
        $A.enqueueAction(action);
    },

    showCurrentUserName: function (component, event) {
        var action = component.get('c.getCurrentUserName');
        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState(),
                name = response.getReturnValue();

            if (state === 'SUCCESS') {
                component.set('v.name', name);
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
    }
})