({
    doInit : function(component, event, helper) {
        component.set('v.currentMenu', {
            titles: [],
            items: []
        });
        component.set('v.currentLvl', 1);
        component.set('v.currentTitle', '');
        
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
            component.set('v.currentLvl', 1);
            component.set('v.currentTitle', '');
            component.set('v.currentMenu', {
                titles: [],
                items: [0, items]
            });
        }
    },
    onChangeLvl: function(component, event, helper) {
        var data = (!!event.getParam)? event.getParam("data"): { where: 'prev' },
            menu = component.get('v.currentMenu'),
            items = component.get('v.menuList'),
            lvl = component.get('v.currentLvl'),
            title = '';
        
        switch (data.where) {
            case 'next': {
                if (data.title) {
                    lvl++;
                    menu.titles[lvl] = data.title;
                    for (var i in items) {
                        if (items[i].id == data.id) {
                            items = items[i].subMenu;
                            break;
                        }
                    }
                    menu.items[lvl] = items;
                }
                break;
            }
            default: {
                lvl = lvl - 1;
                if (menu.titles.length > 0) {
                    items = menu.items[lvl];
                    menu.titles.pop();
                    menu.items.pop();
                }
                break;
            }   
        }
        component.set('v.currentTitle', menu.titles[lvl]);
        component.set('v.currentLvl', lvl);
        component.set('v.menuList', items);
        component.set('v.currentMenu', menu);
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