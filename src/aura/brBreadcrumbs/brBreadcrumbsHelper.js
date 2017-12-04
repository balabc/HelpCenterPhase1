
({
    processStaff: function(component, event) {
        try {
            var action = component.get("c.doStaff"),
            recordId = component.get("v.recordId");
            action.setParams({
            	fullurl : window.location.href,
            	recordId : recordId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var output = response.getReturnValue();
                    component.set("v.isReady", true);
                    var subitems = [];
                    output.forEach(function(item, index, array) {
                        if(item.type == 'home'){
                            component.set("v.breadCrumbHome", item);
                        }
                        if(item.type == 'debug'){
                            console.log('debug',item.label);
                        }
                        if(item.type == 'root'){
                            component.set("v.breadCrumbRoot", item);
                        }
                        if(item.type == 'parent'){
                            component.set("v.breadCrumbParent", item);
                        }
                        if(item.type == 'subitem'){
                            item.active = (item.active == 'true')?true:false;
                            subitems.push(item);
                        }
                    });
                    if(subitems.length > 0){
                        component.set("v.breadCrumbSubItems", subitems);
                    }
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