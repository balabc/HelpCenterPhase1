({
    doInit : function(component, event, helper) {
        component.set('v.routeInputForNews', {recordId: component.get('v.news').item.Id});
    },
    navigateTosObject : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");

        navEvt.setParams({
            "recordId": component.get('v.news').item.Id
        });
        navEvt.fire();
    }
})