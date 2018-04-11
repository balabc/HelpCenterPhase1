({
    doInit: function (cmp, event) {
        var device = $A.get("$Browser.formFactor");
        if ($A.get("$Browser.formFactor") === 'PHONE') {
            window.onscroll = function () {
                var mobileHeader = document.getElementsByClassName('header-mobile')[0];
                if (window.scrollY > 0) {
                    $A.util.addClass(mobileHeader, "header-mobile--make-sticky");
                } else {
                    $A.util.removeClass(mobileHeader, "header-mobile--make-sticky");
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
        //console.log('[DEBUG] brHeaderMobile:toggleSearch');
        var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
        toggleSearchModal.fire();
	},
    toggleMobileMenu: function(component, event, helper) {
        // var menu_btn = event.target.closest('.header-mobile__menu-button');
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