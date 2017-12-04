({
    doInit : function(component, event, helper) {
        helper.processStaff(component, event);
    },
    toggleCrumbs : function(component, event, helper) {
        var crumbPics = document.getElementsByClassName('breadcrumbs__dropdown');
        for(var i=0;crumbPics.length>i;i++){
            crumbPics[i].classList.toggle('breadcrumbs__dropdown--active');
        }
        var crumbList = document.getElementsByClassName('breadcrumbs__dropdown-trigger-text');
        for(var i=0;crumbPics.length>i;i++){
            crumbList[i].classList.toggle('breadcrumbs__dropdown-trigger-text--active');
        }
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