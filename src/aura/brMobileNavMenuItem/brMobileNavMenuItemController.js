({
    onClick : function(component, event, helper) {
        var li = event.target.closest('.header-mobile__menu-link');
        helper.changeLocation(component, li); 
    },
    onChangeLvl: function(component, event, helper) {
        var li = event.target.closest('.header-mobile__menu-item'),
            data = li.getAttribute('data-target');
        
        if (data) {
            helper.changeLocation(component, li);
        }
        
        helper.changeMobileMenuLvl(component, {
            id: li.getAttribute('data-id'),
            title: li.getAttribute('data-title'),
            where: li.getAttribute('data-where')
        });
    }
})