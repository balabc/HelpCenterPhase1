({
    openPage: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL"),
        findClass = event.target;

        while (findClass.getAttribute('class') != 'panel-media') {
            findClass = findClass.parentNode;
        }

        var url = findClass.getAttribute('id');

        urlEvent.setParams({
            "url": '/' + url
        });

        urlEvent.fire();
    }
})