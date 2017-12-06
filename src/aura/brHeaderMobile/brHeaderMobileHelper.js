({
	toggleMobileMenu: function(menu_icon) {
		var isActive = menu_icon.getAttribute('data-active'),
            body_classes = document.body.classList,
            class_is_mobile = 'is-mobile', 
            class_mobile = 'mobile-menu-is-active';
        if (isActive == 'true') {
            if (body_classes.contains(class_mobile)) {
                body_classes.remove(class_mobile);
            }
        } else {
            var body_classes = document.body.classList,
                class_is_mobile = 'is-mobile', 
                class_mobile = 'mobile-menu-is-active';
            
            if (body_classes.contains(class_is_mobile)) {
                if (body_classes.contains(class_mobile)) {
                    body_classes.remove(class_mobile);
                } else {
                    body_classes.add(class_mobile);
                }
            }
        }
	}
})