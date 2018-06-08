({
    toggleSubMenu: function (cmp, event, helper) {
        var cmpEvent = cmp.getEvent("prevActiveMenuItem"),
            Id = '',
            prevActiveMenuId = cmp.get('v.prevActiveMenuItemId'),
            announcementBlockElement = document.getElementsByClassName('announcement-block')[0],
            dropdownWrap = cmp.find('dropdownWrap'),
            menuItemId = cmp.get('v.menuItem').id;

        if (menuItemId !== prevActiveMenuId) {
            Id = menuItemId;
        }

        if ( ((menuItemId === prevActiveMenuId) || prevActiveMenuId === undefined || prevActiveMenuId === '') && window.scrollY === 0) {
            var themeHeader = document.getElementById("themeHeader");

            if (menuItemId === prevActiveMenuId) {
                setTimeout( function () {
                    $A.util.toggleClass(themeHeader, "header--make-sticky");
                      }, 750);
                if (announcementBlockElement !== undefined) {
                    announcementBlockElement.style.position = 'relative';
                    announcementBlockElement.style.zIndex = '0';
                }
            } else {
                $A.util.toggleClass(themeHeader, "header--make-sticky");
            }
        }

        if (announcementBlockElement !== undefined) {
            document.getElementsByClassName('header--make-sticky')[0].style.top = announcementBlockElement.clientHeight + 'px';
            cmp.set('v.top', 70 + announcementBlockElement.clientHeight + 'px')
        } else {
            cmp.set('v.top', '70px');
        }

        cmpEvent.setParams({
            "Id": Id
        });

        cmpEvent.fire();
    },
    closeSubMenu: function (cmp, event, helper) {
        var cmpEvent = cmp.getEvent("prevActiveMenuItem"),
            Id = '',
            prevActiveMenuId = cmp.get('v.prevActiveMenuItemId'),
            menuItemId = cmp.get('v.menuItem').id,
            themeHeader = document.getElementById("themeHeader");

        setTimeout( function () {
            $A.util.removeClass(themeHeader, "header--make-sticky");
        }, 750);

        cmpEvent.setParams({
            "Id": Id
        });

        cmpEvent.fire();
    },
    onClick: function(component, event) {
        var id = event.target.dataset.menuItemId;
        if (id) {
            component.getSuper().navigate(id);
        }
    }
})