({
	toggleSearchModal: function(component, event, helper) {
        console.log('TOGGLE:brSearchModalController.toggleSearchModal()');
		component.set('v.stateSearchModal', !component.get('v.stateSearchModal'));
	}
})