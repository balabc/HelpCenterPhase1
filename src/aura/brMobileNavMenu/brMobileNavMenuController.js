({
    doInit: function(component, event, helper) {
        component.set('v.menuIds', [0]);
        component.set('v.currentObj', undefined);
        
        helper.getNavigationMenu(component);
        helper.getUserInfo(component); 
        helper.fillPhoneList(component);       
    },
    changeUser: function(component, event, helper) {
        var items = component.get('v.menuItems'),
            user = component.get('v.user'),
            locationPage = window.location.pathname.replace('/support/s', ''),
            menuItems;
        
        
        if (items.length > 0) {
            items.shift();
            items.push({id: 'contact', label: $A.get('$Label.c.lnkContact'), hasSubMenu: true, subMenu: [
                {id: 'articles', label: $A.get('$Label.c.lnkArticles')},
                {id: 'learning_guides', label: 'Learning Guides'},
                {id: 'videos', label: $A.get('$Label.c.lnkVideos')},
                {id: 'developer_docs', label: $A.get('$Label.c.lnkDeveloperDocs'), icon: 'icon-svg-docs-sm'},
                {id: 'phone_support', label: $A.get('$Label.c.lnkPhoneSupport'), hasSubMenu: true, subMenu: []}
            ]});
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
            
            
            if (locationPage.length > 1) {
                var menuItems = helper.getCurrentLvl(items, locationPage, 'target');
                if (!!menuItems.obj) {
                    helper.setItemsMenu(component, menuItems);
                } else {
                    locationPage = locationPage.split('/');
                    locationPage = locationPage.pop();
                    helper.getArticleByUrl(component, locationPage);
                }
            }          
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
                currentId = menuIds.pop();
                currentId = menuIds[menuIds.length - 1];
                break;
            }   
        }
        
        
        menuItems = helper.getCurrentLvl(menuItems, currentId);
        menuItems.parents.push(0);
        component.set('v.currentObj', menuItems.obj);
        component.set('v.menuList', menuItems.items);
        component.set('v.menuIds', menuItems.parents.reverse());
        
        
        console.log(menuItems.obj);
    }
})