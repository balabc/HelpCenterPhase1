({
    doInit : function(component, event, helper) {
        component.set('v.routeInputForPopularGroups', {recordId: component.get('v.group').id});
    },
    navigateTosObject : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");

        navEvt.setParams({
            "recordId": component.get('v.group').id
        });
        navEvt.fire();
    }
})