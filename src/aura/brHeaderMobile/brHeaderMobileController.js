({
    doInit: function (cmp, event) {
        console.log('init');
        var device = $A.get("$Browser.formFactor");
        console.log('device: ' + device);
        if ($A.get("$Browser.formFactor") === 'PHONE') {
            window.onscroll = function () {
                var mobileHeader = document.getElementsByClassName('header-mobile')[0];
                    console.log('mobileHeader: ' + mobileHeader);
                if (window.scrollY > 0) {
                    console.log('greater');
                    $A.util.addClass(mobileHeader, "header-mobile--make-sticky");
                } else {
                    console.log('less');
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
        var menu_btn = document.getElementsByClassName('header-mobile__menu-button')[0];
        helper.toggleMobileMenu(menu_btn);
    }
})