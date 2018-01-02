({
    doInit: function (cmp, event) {
        if ($A.get("$Browser.formFactor") === 'PHONE') {
            window.onscroll = function () {
                var mobileHeader = cmp.find('header-mobile').getElement();

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
    },
    toggleSearch: function(component, event, helper) {
        var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
        toggleSearchModal.fire();
	},
    toggleMobileMenu: function(component, event, helper) {
        var menu_btn = event.target.closest('.header-mobile__menu-button');
        helper.toggleMobileMenu(menu_btn);
    },
    toggleMobileMenuExternal: function(component, event, helper) {
        var menu_btn = document.getElementsByClassName('header-mobile__menu-button')[0];
        helper.toggleMobileMenu(menu_btn);
    }
})