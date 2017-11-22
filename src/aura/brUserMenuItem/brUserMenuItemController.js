({
    openNewWindow: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL"),
            menuItem = cmp.get('v.menuItem'),
            url = menuItem.url;

        if (menuItem.url == 'profile' || menuItem.url == 'settings') {
            url += '/'+cmp.get('v.userId');
        }

        if (!cmp.get('v.menuItem').new_window) {
            url = '/' + url;
        }

        urlEvent.setParams({
            "url": url
        });

        urlEvent.fire();
    }
})