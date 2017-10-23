({
	doInit : function(component, event, helper) {
		var action = component.get("c.getCategories");
		var categories = component.find("categories");

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === 'SUCCESS') {
                component.set("v.categories", response.getReturnValue());
            }

            $A.util.removeClass(categories, "slds-hide");
        });

        $A.enqueueAction(action);
	}
})