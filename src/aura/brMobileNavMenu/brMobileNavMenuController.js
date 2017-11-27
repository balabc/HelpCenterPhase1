({
	doInit : function(component, event, helper) {
        component.set('v.currentMenu', {
            titles: [],
            items: []
        });
        component.set('v.currentLvl', 1);
        component.set('v.currentTitle', '');
        document.addEventListener('DOMContentLoaded', function(){
            var funcMenu = function() {  
                var menu_icon = document.getElementsByClassName('header-mobile__menu-icon')[0],
                    isActive = menu_icon.getAttribute('data-active'),
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
            };
            document.getElementsByClassName('header-mobile__menu-icon')[0].addEventListener('click', funcMenu);
            
        });   
        helper.getUserInfo(component); 
        helper.fillPhoneList(component);        
	},
    changeUser: function(component, event, helper) {
        var items = component.get('v.menuItems'),
            user = component.get('v.user');
        
        
        if (items.length > 0) {
            items.shift();
            items.push({id: 'contact', label: $A.get('$Label.c.lnkContact'), subMenu: [
                {id: 'articles', label: $A.get('$Label.c.lnkArticles')},
                {id: 'learning_guides', label: 'Learning Guides'},
                {id: 'videos', label: $A.get('$Label.c.lnkVideos')},
                {id: 'developer_docs', label: $A.get('$Label.c.lnkDeveloperDocs'), icon: 'icon-svg-docs-sm'},
                {id: 'phone_support', label: $A.get('$Label.c.lnkPhoneSupport'), subMenu: []}
            ]});
            items.push({
                id: 'login', 
                label: $A.get('$Label.c.lnkLogIn'),
                type: 4, 
                source: '/s/login/'
            });	 
            
            if (user) {
                items.pop();
                items.push({
                    id: 'user', 
                    label: user.name, 
                    has_picture: true,
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
    nextLvlMenu : function(component, event, helper) {
		var menu = component.get('v.currentMenu'),
            li = event.target.closest('.header-mobile__menu-item'),
            title = li.getAttribute('data-title'),
            id = li.getAttribute('data-id'),
            items = component.get('v.menuList'), 
            lvl = component.get('v.currentLvl');
        
        if (title) {
            lvl++;
        	component.set('v.currentLvl', lvl);
        	menu.titles[lvl] = title;
            component.set('v.currentTitle', title);
            for (var i in items) {
                if (items[i].id == id) {
                    items = items[i].subMenu;
                    break;
                }
            }
            menu.items[lvl] = items;
        	component.set('v.currentMenu', menu);
            component.set('v.menuList', items);  
        }
	},
    prevLvlMenu : function(component, event, helper) {
		var menu = component.get('v.currentMenu'),
            items = component.get('v.menuList'),
            lvl = component.get('v.currentLvl');
        
        lvl = lvl - 1;
        component.set('v.currentLvl', lvl);
        
        if (menu.titles.length > 0) {
            component.set('v.currentTitle', menu.titles[lvl]);
            items = menu.items[lvl];
            menu.titles.pop();
            menu.items.pop();
        }
        component.set('v.menuList', items);
        component.set('v.currentMenu', menu);
	},
    onClick : function(component, event, helper) {
        var link = event.target.closest('.header-mobile__menu-link'),
            type = parseInt(link.getAttribute('data-type')),
            data = link.getAttribute('data-source'),
        	id = link.dataset.menuItemId,
            urlEvent;
        
        switch (type) {
            case 1: { 
                if (id) {
                    component.getSuper().navigate(id);
                }
                break; 
            }
            case 2: {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToURL');
                    urlEvent.setParams({
                        'url': data
                    });
                    urlEvent.fire();
                }
                break;
            } 
            case 3: {
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