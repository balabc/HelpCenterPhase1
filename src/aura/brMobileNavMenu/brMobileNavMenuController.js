({
    doInit: function(component, event, helper) {
        component.set('v.menuIds', [0]);
        component.set('v.currentObj', undefined);
        component.set('v.menuList', []);
        component.set('v.menuItems', []);

        helper.getNavigationMenu(component);
        helper.fillPhoneList(component);
    },
    onChangeLvl: function(component, event, helper) {
        var data = (!!event.getParam)? event.getParam("data"): { where: 'prev' },
            isClick = (!!data.isClick)? true: false,

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

                if (menuIds.length === 1) {
                    currentId = menuIds[menuIds.length - 1];
                } else if (menuIds.length === 2) {
                    currentId = menuIds[menuIds.length - 2];
                }
                break;
            }
        }

        menuItems = helper.getCurrentLvl(menuItems, currentId);

        if (!!menuItems.obj) {
            menuItems.obj.isClick = isClick;
            if (menuItems.obj.isClick) {
                menuItems.obj.id = ' ';
                menuItems.obj.target = ' ';
            }
        }
        helper.setItemsMenu(component, menuItems, true);

    }
})