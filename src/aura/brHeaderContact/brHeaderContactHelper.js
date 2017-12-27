({
    askPageStatus : function(component){
        var statusPanelCmp = component.find("statusPanel");
        var auraMethodResult = statusPanelCmp.reInit();
    },
    fillPhoneList : function(component){
        try {
            var action = component.get("c.getPhoneList");
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var itemsList = response.getReturnValue();
                    //console.log('response:', itemsList);
                    component.set("v.phoneList", itemsList);
                    component.set("v.phoneCount", itemsList.length);
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

        }catch(e){
            console.log('tryE:', e);
        }
    }
})