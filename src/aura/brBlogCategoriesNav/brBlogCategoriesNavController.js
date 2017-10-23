({
	showModal: function(component, event) {
        var modalbox = component.find('modalbox'),
            addButton = component.find('addButton');
        $A.util.addClass(modalbox, 'slds-fade-in-open');
        $A.util.addClass(addButton, 'slds-backdrop--open');
    },

    hideModal: function(component, event) {
        var modalbox = component.find('modalbox'),
            addButton = component.find('addButton');
        $A.util.removeClass(addButton, 'slds-backdrop--open');
        $A.util.removeClass(modalbox, 'slds-fade-in-open');
        var categories = component.find('categories');
        $A.util.addClass(categories, 'slds-hide');        
    },

    toggleCategories: function(component, event) {
        var categories = component.find('categories');
        $A.util.toggleClass(categories, 'slds-show');

        var navIcon = component.find('navIcon');

        if (navIcon.get('v.iconName') === 'utility:chevronright') {
            navIcon.set('v.iconName', 'utility:chevrondown');
        }
        else {
            navIcon.set('v.iconName', 'utility:chevronright');
        }

    },

    doInit : function(component, event, helper) {
        var categories = component.find('categories');
        $A.util.addClass(categories, 'slds-hide');

        var action = component.get("c.getCategories");

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === 'SUCCESS') {
                component.set("v.categories", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    }
})