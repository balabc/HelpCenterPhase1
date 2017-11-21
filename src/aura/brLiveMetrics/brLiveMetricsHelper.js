({
	getData : function(component, outVar, method, params) {
        var action = component.get(method);
        if (params !== false)
        	action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState(),
                data;
            if (state === "SUCCESS") {
                data = response.getReturnValue();
                console.log(method, data);
                component.set(outVar, data);
            }
        });
        $A.enqueueAction(action);
    },
	getIdComm : function(component, outVar, method, params) {
        var action = component.get(method),
            self = this;
        if (params !== false)
        	action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState(),
                data;
            if (state === "SUCCESS") {
                data = response.getReturnValue();
                component.set(outVar, data);
                var networkId = component.get('v.networkId');
         		self.getData(component, 'v.solutions', 'c.getFeedItemCount', false);
                self.getData(component, 'v.members', 'c.getUserCount', {networkId:networkId});
				self.getData(component, 'v.ideas', 'c.getIdeaCount', {networkId:networkId});             
            }
        });
        $A.enqueueAction(action);
    }    
})