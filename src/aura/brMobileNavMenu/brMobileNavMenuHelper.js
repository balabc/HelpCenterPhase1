({
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
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);

        }catch(e){
            console.log('tryE:', e);
        }
    },
    getUserInfo : function(component){
        try {
            var action = component.get("c.getUserInfo");
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {      
                    component.set("v.user", response.getReturnValue());
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);

        }catch(e){
            console.log('tryE:', e);
        }
    }    
})