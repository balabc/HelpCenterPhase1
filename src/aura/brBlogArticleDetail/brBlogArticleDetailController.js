({
	doInit: function(component, event, helper) {
        var spinner = component.find("spinner");
        $A.util.toggleClass(spinner, "slds-show");

        var action = component.get("c.getArticle");
        action.setParams({ articleId : component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === 'SUCCESS') {
                component.set("v.wrap", response.getReturnValue());
            }

            $A.util.toggleClass(spinner, "slds-hide");
            var componentButtons = component.find("componentButtons");
            $A.util.removeClass(componentButtons, "slds-hide");
        });

        $A.enqueueAction(action);
	},

    showListArticles: function(component, event, helper) {
        history.back();
    }
})