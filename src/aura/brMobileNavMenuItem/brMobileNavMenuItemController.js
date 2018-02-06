({
    onClick : function(component, event, helper) {
        var li = event.target.closest('.header-mobile__menu-link');
        helper.changeLocation(component, li); 
        if (!!li.getAttribute('data-toggle-menu'))
        	helper.changeMobileMenuToggle();
        var closeMenu = $A.get("e.c:brMobileNavMenuToggleEvent");
        closeMenu.fire();
    },
    onChangeLvl: function(component, event, helper) {
        var li = event.target.closest('.header-mobile__menu-item'),
            data = li.getAttribute('data-target');

        if (data) {
            helper.changeLocation(component, li);
        }
        
        helper.changeMobileMenuLvl(component, {
            id: li.getAttribute('data-id'),
            isClick: true,
            title: li.getAttribute('data-title'),
            where: li.getAttribute('data-where')
        });
    }
})