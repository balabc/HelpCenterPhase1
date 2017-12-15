({
    doInit: function(component, event, helper) {
        var device = $A.get("$Browser.formFactor");
        if (device === 'PHONE') {
            component.set('v.menuIds', [0]);
            component.set('v.currentObj', undefined);        
            component.set('v.menuList', []);       
            component.set('v.menuItems', []);
            
            helper.getNavigationMenu(component);
            helper.fillPhoneList(component);
        }
    },
    onChangeLvl: function(component, event, helper) {
        var data = (!!event.getParam)? event.getParam("data"): { where: 'prev' },
            menuItems = component.get('v.menuItems'),
			menuIds = component.get('v.menuIds'),     
			currentId = undefined;
        
        
        switch (data.where) {
            case 'next': {
                if (data.id) {
                    currentId = data.id;
                    menuIds.push(currentId);
                }
                break;
            }
            default: {
        		component.find('brCategoriesCMP').nullData();
                currentId = menuIds.pop();
                currentId = menuIds[menuIds.length - 1];
                break;
            }   
        }
        
        menuItems = helper.getCurrentLvl(menuItems, currentId);
        helper.setItemsMenu(component, menuItems, true);
    }
})