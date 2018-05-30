({
    doInit: function (cmp, event) {
        var device = $A.get("$Browser.formFactor");
        if ($A.get("$Browser.formFactor") === 'PHONE') {
            window.onscroll = function () {
                var mobileHeader = document.getElementsByClassName('header-mobile')[0],
                    announcementBlockElement = document.getElementsByClassName('announcement-block')[0],
                    cnHeaderStickyElement = document.getElementsByClassName('header-mobile--make-sticky')[0];
                if (window.scrollY > 0) {
                    $A.util.addClass(mobileHeader, "header-mobile--make-sticky");
                    if (announcementBlockElement !== undefined) {
                        var announcementBlockHeight = announcementBlockElement.clientHeight - 1;
                        cnHeaderStickyElement.style.top = announcementBlockHeight + 'px';
                        announcementBlockElement.style.position = 'fixed';
                        announcementBlockElement.style.zIndex = '4';
                    } else {
                        cnHeaderStickyElement.style.top = '0';
                        announcementBlockElement.style.position = 'relative';
                        announcementBlockElement.style.zIndex = '0';
                    }
                } else {
                    $A.util.removeClass(mobileHeader, "header-mobile--make-sticky");
                    cnHeaderStickyElement.style.top = '0';
                    announcementBlockElement.style.position = 'relative';
                    announcementBlockElement.style.zIndex = '0';
                }
            };
        }
    },
    showHomePage: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");

        urlEvent.setParams({
            "url": '/'
        });

        urlEvent.fire();

        if (window.location.href.indexOf('/login') !== -1) {
            var url = window.location.href;
            url = url.replace('/login', '');
            window.location.href = url;
        }

        var navigationMenuInit = $A.get("e.c:brNavigationMenuInitEvent");
        navigationMenuInit.fire();
    },
    toggleSearch: function(component, event, helper) {
        var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
        toggleSearchModal.fire();
	},
    toggleMobileMenu: function(component, event, helper) {
        helper.toggleMobileMenu(component, event);
    },
    closeMenu: function(component, event, helper) {
        document.body.classList.remove('mobile-menu-is-active');
    },
    toggleMobileMenuExternal: function(component, event, helper) {
        document.body.classList.remove('mobile-menu-is-active');
        helper.hidePlugs(component);
    }
})