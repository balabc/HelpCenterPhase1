({
    getPageNumber: function (cmp, event, helper) {
        var pageNumber = cmp.find("page").get("v.value"),
            pageNumberEvent = cmp.getEvent("setVideosPage");

        pageNumberEvent.setParams({
            pageNumber: pageNumber
        });
        pageNumberEvent.fire();
    }
})