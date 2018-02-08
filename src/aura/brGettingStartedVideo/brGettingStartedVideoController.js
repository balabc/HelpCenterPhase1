({
    openVideosPage: function (cmp, event, helper) {
        document.getElementsByClassName("moreVideos")[0].removeAttribute("href");
        var urlEvent = $A.get("e.force:navigateToURL");

        urlEvent.setParams({
            "url": '/videos'
        });

        urlEvent.fire();
    }
})