({
    doInit : function(component, event, helper) {
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
	toggleSearchModal : function(component, event, helper) {
		var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
        toggleSearchModal.fire();
	},
    changeSearch : function(component, event, helper) {
        var search = event.getParam("search");
        component.set('v.search', search);
	},
	toggleHeaderContact : function(component, event, helper) {
        var childCmp = component.find("childHeaderContact");
        var auraMethodResult = childCmp.showMe();
    }

})