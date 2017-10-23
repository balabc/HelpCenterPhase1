({
    getResponse: function(component) {
        var action = component.get("c.getCatalog"),
            selectId = component.get('v.selectedArticleId');
        if (!!selectId) { 
            console.log(selectId);
            action.setParams({ 
                selectId : selectId
            });
        }
               
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('res',res);
                component.set("v.items", res);
            }
        });
        $A.enqueueAction(action);
    }
})