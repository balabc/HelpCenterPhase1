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
        component.set('v.currentMenu', {lvl: 1, title: ''});
	},
    nextLvlMenu : function(component, event, helper) {
        console.log(event.target);
		var menu = component.get('v.currentMenu'),
            title = event.target.closest('.header-mobile__menu-item').getAttribute('data-title');
        if (title) {
        	menu.lvl++;
            if (menu.titles === undefined)
            	menu.titles = [];
        	menu.titles[menu.lvl] = title;
        	menu.title = title;
        	component.set('v.currentMenu', menu);
        }
	},
    prevLvlMenu : function(component, event, helper) {
		var menu = component.get('v.currentMenu');
        menu.lvl = menu.lvl - 1;
        if (menu.titles.length > 0) {
            menu.title = menu.titles[menu.lvl];
            menu.titles.pop();
        }
        component.set('v.currentMenu', menu);
	},
    onClick : function(component, event, helper) {
        var id = event.target.dataset.menuItemId;
        if (id) {
            component.getSuper().navigate(id);
         }
   }
})