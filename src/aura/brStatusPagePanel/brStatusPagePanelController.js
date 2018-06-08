
({
    doInit : function(component, event, helper) {
        helper.checkPageStatus(component);
        helper.updatePageStatusData(component);
        var  timeInterval = setInterval(function(){helper.timeInc(component);}, 60000);//1 minute
    },
    openPageStatus : function(component){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "http://status.bigcommerce.com"
        });
        urlEvent.fire();
    }
})