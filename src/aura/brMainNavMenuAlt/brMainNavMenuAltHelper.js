({
    getNavigationMenuItemExternalLabels: function (cmp) {
        var action = cmp.get("c.getLabels");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var labels = response.getReturnValue();
                console.log('labels: ' + labels);
                cmp.set('v.labels', labels);
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
    }
})