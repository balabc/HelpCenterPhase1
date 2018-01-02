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
    }  
})