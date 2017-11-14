({
	toggleSearchModal : function(component, event, helper) {
		var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
        console.log('TOGGLE:brThemeHeaderController.toggleSearchModal()');
        toggleSearchModal.fire();
	}
})