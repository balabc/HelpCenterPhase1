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
        var param = event.getParam,
            data = (!$A.util.isUndefinedOrNull(param) && !$A.util.isEmpty(param))? param("data"): { where: 'prev' },
            isClick = (!$A.util.isUndefinedOrNull(data.isClick) && !$A.util.isEmpty(data.isClick))? true: false,

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

        var obj = menuItems.obj;

        if (!$A.util.isUndefinedOrNull(obj) && !$A.util.isEmpty(obj)) {
            obj.isClick = isClick;
            if (obj.isClick) {
                obj.id = ' ';
                obj.target = ' ';
            }
        }
        helper.setItemsMenu(component, menuItems, true);

    }
})