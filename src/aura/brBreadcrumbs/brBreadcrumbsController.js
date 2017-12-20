({
    doInit : function(component, event, helper) {
        if($A.get("$Browser.formFactor") === 'PHONE')
            return;
        helper.processCrumbs(component, event);
    },
    toggleCrumbs : function(component, event, helper) {
        helper.toggleCrumbs(component);
    },
    onClick : function(component, event, helper) {
        var menuType = event.target.dataset.type;
        var target = event.target.dataset.value;
        if(menuType == 'SalesforceObject'){
            var listviewid = event.target.dataset.listviewid;
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": listviewid,
                "listViewName": null,
                "scope": target
            });
            navEvent.fire();
        }else{
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": target
            });
            urlEvent.fire();
        }
    }
})