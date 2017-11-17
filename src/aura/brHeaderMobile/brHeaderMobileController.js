({
    toggleSearch: function(component, event, helper) {
        var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
        toggleSearchModal.fire();
	}
})