({
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