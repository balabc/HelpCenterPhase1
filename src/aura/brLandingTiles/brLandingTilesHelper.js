({
    gotoList : function (component) {
        var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var view = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": view.Id,
                    "listViewName": null,
                    "scope": "CollaborationGroup"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})