({
    doInit: function (component, event, helper) {
        window.onscroll = function () {
            var cnHeader = 'header',
                cnHeaderSticky = 'header--make-sticky',
                cnSubstrate = 'header__dropdown-menu-substrate',
                cnSubstrateActive = 'header__dropdown-menu-substrate--active',
                announcementBlock = 'announcement-block',
                announcementBlockElement = document.getElementsByClassName(announcementBlock)[0],
                cnHeaderStickyElement = document.getElementsByClassName(cnHeaderSticky)[0],
                prevActiveMenuItem = component.get('v.prevActiveMenuItemId');
            var header = document.getElementsByClassName(cnHeader)[0],
                substrate = document.getElementsByClassName(cnSubstrate)[0];

            if ((window.scrollY > 0 || (prevActiveMenuItem !== '' && prevActiveMenuItem !== undefined && window.scrollY === 0))
                && header !== undefined) {
                header.classList.add(cnHeaderSticky);
                if (announcementBlockElement !== undefined) {
                    var announcementBlockHeight = announcementBlockElement.clientHeight;
                    cnHeaderStickyElement.style.top = announcementBlockHeight + 'px';
                    announcementBlockElement.style.position = 'fixed';
                    announcementBlockElement.style.zIndex = '4';
                } else {
                    cnHeaderStickyElement.style.top = '0';
                    announcementBlockElement.style.position = 'relative';
                    announcementBlockElement.style.zIndex = '0';
                }
            } else {
                if (substrate !== undefined && header !== undefined) {
                    if (!substrate.classList.contains(cnSubstrateActive)){
                        header.classList.remove(cnHeaderSticky);
                    }
                }
                announcementBlockElement.style.position = 'relative';
                announcementBlockElement.style.zIndex = '0';
            }
        };

        helper.getNavigationMenuItemExternalLabels(component);
    },
    onClick : function(component, event) {
        var id = event.target.dataset.menuItemId;

        if (id) {
            component.getSuper().navigate(id);
            if (window.location.href.indexOf('/login') !== -1) {
                var url = window.location.href;
                url = url.replace('/login', '');
                window.location.href = url;
            }
        }
    },
    setMenuItemId: function (component, event) {
        var Id = event.getParam("Id");
        component.set('v.prevActiveMenuItemId', Id);
    },
    closeSubMenu: function (component, event) {
        var dropdown = document.getElementsByClassName("header__wrap-dropdown-menu--active"),
            themeHeader = document.getElementById("themeHeader");
        $A.util.removeClass(dropdown[0], "header__wrap-dropdown-menu--active");
        setTimeout( function () {
            $A.util.removeClass(themeHeader, "header--make-sticky");
        }, 750);
    }
})