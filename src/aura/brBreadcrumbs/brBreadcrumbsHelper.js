({
    processStaff: function(component, event) {
        try {
            var action = component.get("c.getBreadCrumbsData"),
            recordId = component.get("v.recordId");
            action.setParams({
            	fullurl : window.location.href,
            	recordId : recordId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var output = response.getReturnValue();
                    console.log('crumbsDEBUG:', output.debug);
                    component.set("v.breadCrumbHome", output.homeCrumb);
                    component.set("v.breadCrumbRoot", output.rootCrumb);
                    component.set("v.breadCrumbParent", output.parentCrumb);
                    component.set("v.breadCrumbSubItems", output.subItems);
                    component.set("v.isReady", true);
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log("Errors: ", errors);
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