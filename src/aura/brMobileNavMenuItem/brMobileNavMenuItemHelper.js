({
	changeMobileMenuLvl: function(component, data) {
		var itemAction = component.getEvent('eventMobileNavMenuItem');
        
        itemAction.setParams({
            data: data
        });
        itemAction.fire();
	},
    changeMobileMenuToggle: function() {
        var toggleMenu = $A.get('e.c:brMobileNavMenuToggleEvent');
        toggleMenu.fire();
	},
    changeLocation: function(component, link) {
        var type = link.getAttribute('data-type'),
            data = link.getAttribute('data-target'),
            id = link.dataset.menuItemId,
            urlEvent;
        
        switch (type) {
            case 'ExternalLink': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToURL');
                    urlEvent.setParams({
                        'url': data
                    });
                    urlEvent.fire();
                }
                break;
            }
            case 'InternalLink': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToURL');
                    urlEvent.setParams({
                        'url': data
                    });
                    urlEvent.fire();
                }
                break;
            }
            case 'SalesforceObject': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToSObject');
                    urlEvent.setParams({
                        'recordId': data
                    });
                    urlEvent.fire();
                }
                break;
            }
            // no default
        }
    }
})