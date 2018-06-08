({
    doInit : function(component, event, helper) {
        component.set('v.routeInputForGroupPosts', {recordId: component.get('v.post').id});
    },
    navigateTosObject : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");

        navEvt.setParams({
            "recordId": component.get('v.post').id
        });
        navEvt.fire();
    }
})