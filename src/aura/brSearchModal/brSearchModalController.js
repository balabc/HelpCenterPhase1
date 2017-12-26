({
	toggleSearchModal: function(component, event, helper) {
        var state = !component.get('v.stateSearchModal'),
            body_classes = document.body.classList,
            class_modal = 'is-modal';  
		component.set('v.stateSearchModal', state);
        
        if (state) { 
            if (!document.body.classList.contains(class_modal))
            	document.body.classList.add(class_modal);
        } else {
            document.body.classList.remove(class_modal);
        }
	},
    onClickSearch: function(component, event, helper) {
	    var target = event.target,
            flag = true,
            classes = [
                'serp__filter-section',
                'serp__panel',
                'searchbox-uniq',
                'serp__filter-trigger-icon'
            ];

        if (!!target && (typeof target.closest !== "undefined")) {
            var clos_modal = target.closest('.modal');
            if (!!clos_modal) {
                for (var i in classes) {
                    var clos = target.closest('.' + classes[i]);
    
                    if (target.className.indexOf(classes[i]) > -1) {
                        flag = false;
                    } else {
                        if (!!clos) {
                            flag = false;
                        }
                    }
                }
    
                if (flag) {
                    var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
                    toggleSearchModal.fire();
                }
            }
        }

        return false;
    }
})