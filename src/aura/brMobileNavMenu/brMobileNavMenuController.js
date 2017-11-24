({
	doInit : function(component, event, helper) {
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
        helper.fillPhoneList(component);    
        helper.getUserInfo(component);    
	},
	changeUser : function(component, event, helper) {
		var items = component.get('v.menuList'),
			us = component.get('v.user');
		if (us) {
			items.pop();
			items.push({
	            id: 'user', 
	            label: us.name, 
	            picture: '<span class="header-mobile__menu-shape"><img src="'+us.photoUrl+'" class="header-mobile__menu-userpic" alt=""></span>',
	            subMenu: [                       
	                {id: 'profile', label: 'Profile', url: '/support/s/profile/' + us.id},
	                {id: 'my_messages', label: 'My Messages', url: '/support/s/messages/Home'},
	                {id: 'my_feed', label: 'My Feed', url: '/support/s/feed'},
	                {id: 'my_cases', label: 'My Cases', url: '/support/s/case'},
	                {id: 'my_files', label: 'My Files', url: '/support/s/MyFeed'},
	                {id: 'log_out', label: 'Log Out', url: '/support/secur/logout.jsp'}
	            ]
	        });		
		}
        component.set('v.menuList', items);
        component.set('v.currentMenu', {
            lvl: 1, 
            title: '',
            titles: [],
            items: [0, items]
        });
	},
    changeMenu : function(component, event, helper) {
        var items = component.get('v.menuItems');
        items.push({id: 'contact', label: 'Contact', subMenu: [
            {id: 'articles', label: 'Articles'},
            {id: 'learning_guides', label: 'Learning Guides'},
            {id: 'videos', label: 'Videos'},
            {id: 'articles', label: 'Articles'},
            {id: 'developer_docs', label: 'Developer Docs', icon: 'icon-svg-docs-sm'},
            {id: 'phone_support', label: 'Phone Support', subMenu: []}
        ]});
        items.push({id: 'notifications', label: 'Notifications'});
        items.push({
            id: 'login', 
            label: 'Login',
            url: '/support/s/login/'  
        });
        
        
        component.set('v.menuList', items);
        component.set('v.currentMenu', {
            lvl: 1, 
            title: '',
            titles: [],
            items: [0, items]
        });
    },
    nextLvlMenu : function(component, event, helper) {
		var menu = component.get('v.currentMenu'),
            li = event.target.closest('.header-mobile__menu-item'),
            title = li.getAttribute('data-title'),
            id = li.getAttribute('data-id'),
            items = component.get('v.menuList'), 
            sub_menu = [];
        
        
        
        if (title) {
        	menu.lvl++;
        	menu.titles[menu.lvl] = title;
        	menu.title = title;
            for (var i in items) {
                if (items[i].id == id) {
                    sub_menu = items[i].subMenu;
                    break;
                }
            }
            menu.items[menu.lvl] = sub_menu;
            console.log(menu);
            
        	component.set('v.currentMenu', menu);
            component.set('v.menuList', sub_menu);  
        }
	},
    prevLvlMenu : function(component, event, helper) {
		var menu = component.get('v.currentMenu'),
            items = [];
        menu.lvl = menu.lvl - 1;
        if (menu.titles.length > 0) {
            console.log(menu);
            menu.title = menu.titles[menu.lvl];
            items = menu.items[menu.lvl];
            component.set('v.menuList', items);
            menu.titles.pop();
            menu.items.pop();
        }
        component.set('v.currentMenu', menu);
	},
    onClick : function(component, event, helper) {
        var id = event.target.closest('.header-mobile__menu-link').dataset.menuItemId;
        if (id) {
            component.getSuper().navigate(id);
         }
   }
})