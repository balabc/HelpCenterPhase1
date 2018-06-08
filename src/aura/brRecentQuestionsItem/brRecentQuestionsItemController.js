({
    doInit : function(component, event, helper) {
        component.set('v.routeInputForQuestions', {recordId: component.get('v.question').id});
    },
    navigateTosObject : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");

        navEvt.setParams({
            "recordId": component.get('v.question').id
        });
        navEvt.fire();
    }
})