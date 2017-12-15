({
    openVideosPage: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");

        urlEvent.setParams({
            "url": '/videos'
        });

        urlEvent.fire();
    }
})