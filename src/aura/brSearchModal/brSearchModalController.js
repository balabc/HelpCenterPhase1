({
    openModal: function(component, event, helper) {
        helper.openModal(component, event);
    },
    closeModal: function(component, event, helper) {
        helper.closeModal(component, event);
    },
	toggleSearchModal: function(component, event, helper) {
        helper.toggleModal(component, event);
	},
    onClickSearch: function(component, event, helper) {
	    var target = event.target,
            flag = true,
            classes = [
                'serp__filter-section',
                'serp__panel',
                'searchbox-uniq',
                'serp__filter-section-panel-inner',
                'serp__filter-trigger-icon'
            ];

        if (!$A.util.isUndefinedOrNull(target) && !$A.util.isEmpty(target) && (typeof target.closest !== "undefined")) {
            var clos_modal = target.closest('.modal');
            if (!$A.util.isUndefinedOrNull(clos_modal) && !$A.util.isEmpty(clos_modal)) {
                for (var i in classes) {
                    var clos = target.closest('.' + classes[i]);
    
                    if (target.className.indexOf(classes[i]) > -1) {
                        flag = false;
                    } else {
                        if (!$A.util.isUndefinedOrNull(clos) && !$A.util.isEmpty(clos)) {
                            flag = false;
                        }
                    }
                }

try{        //ignore further execution if element contains class "filter_ask_to_skip"
            var skip_me = document.getElementsByClassName('serp__filter-closearea')[0];
            if (!!skip_me && (typeof skip_me.classList !== "undefined")) {
                if( skip_me.classList.contains("filter_ask_to_skip") ){
                    skip_me.classList.remove("filter_ask_to_skip");
                    return false;
                }
            }
}catch(eeee){}


                if (flag) {
                    var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
                    toggleSearchModal.fire();
                }
            }
        }

        return false;
    }
})