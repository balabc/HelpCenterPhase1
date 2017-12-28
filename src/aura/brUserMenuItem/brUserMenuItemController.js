({
    openNewWindow: function (cmp, event, helper) {
        var toggleDropdown = document.getElementById('userMenu');
        var arrow = document.getElementById('arrow');
        $A.util.toggleClass(toggleDropdown, "toggle");
        $A.util.toggleClass(arrow, "nav-arrow--up");

        var menuItem = cmp.get('v.menuItem'),
            urlEvent = $A.get("e.force:navigateToURL"),
            location = window.location.href,
            url =  menuItem.url,
            existOldUrlWithProfileOrSettings = false;

        if ((location.includes('profile') || location.includes('settings')) && cmp.get('v.menuItem').new_window) {
            existOldUrlWithProfileOrSettings = true;
            var menuItemFind;

            if (location.includes('profile')) {
                menuItemFind = 'profile';
            }
            if (location.includes('settings')) {
                menuItemFind = 'settings';
            }
            var n = location.indexOf(menuItemFind);
            location = location.substring(0, n != -1 ? n : location.length);
            url = location + url;
        }

        if (menuItem.url == 'profile' || menuItem.url == 'settings') {
            url += '/' + cmp.get('v.userId');
        } else {
            url = menuItem.url;
        }

        if (cmp.get('v.menuItem').new_window) {
            if (existOldUrlWithProfileOrSettings) {
                window.open(url);
            } else {
                urlEvent.setParams({
                    "url": url
                });
                urlEvent.fire();
            }
        } else {
            urlEvent.setParams({
                "url": '/' + url
            });

            urlEvent.fire();
        }
    }
})