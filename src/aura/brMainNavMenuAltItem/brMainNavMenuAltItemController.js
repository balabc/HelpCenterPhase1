({
    showSubMenu: function (cmp, event, helper) {
        var cmpEvent = cmp.getEvent("prevActiveMenuItem"),
            Id = '',
            prevActiveMenuId = cmp.get('v.prevActiveMenuItemId'),
            menuItemId = cmp.get('v.menuItem').id;

        if (menuItemId != prevActiveMenuId) {
            Id = menuItemId;
        }

        if ( ((menuItemId == prevActiveMenuId) || prevActiveMenuId == undefined || prevActiveMenuId == '') && window.scrollY == 0) {
            var themeHeader = document.getElementById("themeHeader");

            if (menuItemId == prevActiveMenuId) {
                setTimeout( function () {
                    $A.util.toggleClass(themeHeader, "header--make-sticky");
                      }, 750);
            } else {
                $A.util.toggleClass(themeHeader, "header--make-sticky");
            }
        }

        cmpEvent.setParams({
            "Id": Id
        });

        cmpEvent.fire();
    }
})