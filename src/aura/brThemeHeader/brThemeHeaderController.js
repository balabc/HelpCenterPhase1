({
	toggleSearchModal : function(component, event, helper) {
		var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
        toggleSearchModal.fire();
	},
    changeSearch : function(component, event, helper) {
        var search = event.getParam("search");
        console.log('2', search);
        component.set('v.search', search);
	},
	toggleHeaderContact : function(component, event, helper) {
        var childCmp = component.find("childHeaderContact");
        var auraMethodResult = childCmp.showMe();
    }

})