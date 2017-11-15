({
	toggleSearchModal : function(component, event, helper) {
		var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
        toggleSearchModal.fire();
	},
    changeSearch : function(component, event, helper) {
        var search = event.getParam("search");
        console.log('2', search);
        component.set('v.search', search);
	}
})