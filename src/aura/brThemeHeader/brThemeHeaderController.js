({
    doInit : function(component, event, helper) {
        //console.log('[DEBUG] [Controller] brThemeHeader:doInit');
        helper.retrieveInitData(component);
        /*document.addEventListener('DOMContentLoaded', function(){
            var funcResizeMobile = function() {  
                var body_classes = document.body.classList,
                        class_is_mobile = 'is-mobile';
                if (window.innerWidth < 993) {
                    if (!body_classes.contains(class_is_mobile)) {  
                        body_classes.add(class_is_mobile);
                    }
                } else {
                    body_classes.remove(class_is_mobile);
                }  
            }; 
            funcResizeMobile();
            window.addEventListener('resize', funcResizeMobile);
        });*/
	},
    showHomePage: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");

        urlEvent.setParams({
            "url": '/'
        });

        urlEvent.fire();
    },
    toggleHeaderContact : function(component, event, helper) {
        var childCmp = component.find("childHeaderContact");
        var auraMethodResult = childCmp.showMe();
    },
    toggleSearchModal : function(component, event, helper) {
        var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
        toggleSearchModal.fire();
    },
    changeSearch : function(component, event, helper) {
        var search = event.getParam("search");
        component.set('v.search', search);
    },
    closeMenu: function(component, event, helper) {
        /*
        var toggleSearchModal = $A.get("e.c:brCloseAllNavMenuEvent");
        toggleSearchModal.fire();
        var m1 = component.find('brMainNavMenu'),
            m2 = component.find('brMainNavMenuAlt');
        if (!!m1) {
            m1.closeMenu();
        }
        if (!!m2) {
            m2.closeMenu();
        }*/
    }
})