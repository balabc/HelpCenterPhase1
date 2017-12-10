({
    doInit : function(cmp) {
        var action = cmp.get("c.serverEcho");

        action.setParams({
            firstName : cmp.get("v.firstName")
        });

        action.setCallback(this, function(response) {
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === "SUCCESS") {

            }
        });

        $A.enqueueAction(action);
    }
})