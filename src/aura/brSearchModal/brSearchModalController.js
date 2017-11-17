({
	toggleSearchModal: function(component, event, helper) {
        var state = !component.get('v.stateSearchModal'),
            body_classes = document.body.classList,
            class_modal = 'is-modal';
        console.log('11112222');
		component.set('v.stateSearchModal', state);
        
        if (state) {
            if (!document.body.classList.contains(class_modal))
            	document.body.classList.add(class_modal);
        } else {
            document.body.classList.remove(class_modal);
        }
	}
})