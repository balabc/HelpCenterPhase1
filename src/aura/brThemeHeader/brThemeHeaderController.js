({
    doInit : function(component, event, helper) {
        helper.retrieveInitData(component);
	},
    showHomePage: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");

        urlEvent.setParams({
            "url": '/'
        });

        urlEvent.fire();

        if (window.location.href.indexOf('/login') !== -1) {
            var url = window.location.href;
            url = url.replace('/login', '');
            window.location.href = url;
        }
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
    }
})