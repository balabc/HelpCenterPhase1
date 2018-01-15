({
    openModal: function(component, event, helper) {
        //console.log('[DEBUG] [Controller] brSearchModal:closeModal');
        helper.openModal(component, event);
    },
    closeModal: function(component, event, helper) {
        //console.log('[DEBUG] [Controller] brSearchModal:closeModal');
        helper.closeModal(component, event);
    },
	toggleSearchModal: function(component, event, helper) {
        //console.log('[DEBUG] [Controller] brSearchModal:toggleSearchModal');
        helper.toggleModal(component, event);
	},
    onClickSearch: function(component, event, helper) {
        console.log('[DEBUG] [Controller] brSearchModal:onClickSearch');
	    var target = event.target,
            flag = true,
            classes = [
                'serp__filter-section',
                'serp__panel',
                'searchbox-uniq',
                'serp__filter-section-panel-inner',
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