({
    doInit : function(component, event, helper) {
        component.set('v.currentTitle', '');
        component.set('v.menuIds', [0]);
        
        helper.getNavigationMenu(component);
        helper.getUserInfo(component); 
        helper.fillPhoneList(component);        
    },
    changeUser: function(component, event, helper) {
        var items = component.get('v.menuItems'),
            user = component.get('v.user');
        
        
        if (items.length > 0) {
            items.shift();
            items.push({id: 'contact', label: $A.get('$Label.c.lnkContact'), hasSubMenu: true, subMenu: [
                {id: 'articles', label: $A.get('$Label.c.lnkArticles')},
                {id: 'learning_guides', label: 'Learning Guides'},
                {id: 'videos', label: $A.get('$Label.c.lnkVideos')},
                {id: 'developer_docs', label: $A.get('$Label.c.lnkDeveloperDocs'), icon: 'icon-svg-docs-sm'},
                {id: 'phone_support', label: $A.get('$Label.c.lnkPhoneSupport'), hasSubMenu: true, subMenu: []}
            ]});
            /*items.push({
                id: 'categories', 
                label: 'Categories',
                type: 'Component',
                target: 'brCategoriesCMP'
            });	*/
            items.push({
                id: 'login', 
                label: $A.get('$Label.c.lnkLogIn'),
                type: 4, 
                target: '/s/login/'
            });	 
            
            if (user) {
                items.pop();
                items.push({
                    id: 'user', 
                    label: user.name, 
                    has_picture: true,
                    hasSubMenu: true,
                    picture: '<span class="header-mobile__menu-shape"><img src="' + user.photoUrl + '" class="header-mobile__menu-userpic" alt=""></span>',
                    subMenu: helper.getSubMenuUser(component, user)
                });		
            }
            
            component.set('v.menuList', items);
            component.set('v.currentTitle', '');
        }
    },
    onChangeLvl: function(component, event, helper) {
        var data = (!!event.getParam)? event.getParam("data"): { where: 'prev' },
            menu = component.get('v.currentMenu'),
            items = component.get('v.menuList'),
            lvl = component.get('v.currentLvl'),
            title = '';
        
        var menuItems = component.get('v.menuItems'),
			menuIds = component.get('v.menuIds'),     
			currentId = undefined;
        
        switch (data.where) {
            case 'next': {
                if (data.title) {
                    currentId = data.id;
                    menuIds.push(currentId);
                }
                break;
            }
            default: {
                currentId = menuIds.pop();
                currentId = menuIds[menuIds.length - 1];
                break;
            }   
        }
        
        menuItems = helper.getCurrentLvl(menuItems, currentId);
        
        component.set('v.currentTitle', menuItems.title);
        component.set('v.menuList', menuItems.items);
        component.set('v.menuIds', menuIds);
    },
    onClick: function(component, event, helper) {
        var link = event.target.closest('.header-mobile__menu-link'),
            type = link.getAttribute('data-type'),
            data = link.getAttribute('data-target'),
            id = link.dataset.menuItemId,
            urlEvent;
        
        switch (type) {
            case 'InternalLink': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToURL');
                    urlEvent.setParams({
                        'url': data
                    });
                    urlEvent.fire();
                }
                break;
            } 
            case 'SalesforceObject': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToSObject');
                    urlEvent.setParams({
                        'recordId': data
                    });
                    urlEvent.fire();
                }
                break;
            } 
        }
    }
})