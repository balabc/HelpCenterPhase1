({
	toggleMobileMenu: function(component, event) {
		var menu_icon = component.find('header-mobile__menu-button').getElement(),
            isActive = menu_icon.getAttribute('data-active'),
            body_classes = document.body.classList,
            class_is_mobile = 'is-mobile', 
            class_mobile = 'mobile-menu-is-active';
        if (isActive === 'true') {
            if (body_classes.contains(class_mobile)) {
                body_classes.remove(class_mobile);
                this.hidePlugs(component, event);
            }
        } else {
            body_classes = document.body.classList;
            class_is_mobile = 'is-mobile';
            class_mobile = 'mobile-menu-is-active';
            
            if (body_classes.contains(class_is_mobile)) {
                if (body_classes.contains(class_mobile)) {
                    body_classes.remove(class_mobile);
                    this.hidePlugs(component, event);
                } else {
                    body_classes.add(class_mobile);
                    this.showPlugs(component, event);
                }
            }
        }
	},
    showPlugs: function(component, event) {
        //console.log('[DEBUG] [Helper] brHeaderMobile:showPlugs');
        $A.util.addClass(component.find('header-plugs'), 'show');
    },
    hidePlugs: function(component, event) {
        //console.log('[DEBUG] [Helper] brHeaderMobile:hidePlugs');
        $A.util.removeClass(component.find('header-plugs'), 'show');
    }
})