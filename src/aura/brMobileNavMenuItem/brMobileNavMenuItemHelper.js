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
                this.changeLocationForLoginPage(component);
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
                this.changeLocationForLoginPage(component);
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
                this.changeLocationForLoginPage(component);
                break;
            }
			case 'navigateToList': {
                if (data) {
                    urlEvent = $A.get("e.force:navigateToList");
                    urlEvent.setParams({
                        "listViewId": id,
                        "listViewName": null,
                        "scope": data
                    });
                    urlEvent.fire();
                }
                this.changeLocationForLoginPage(component);
                break;
            }			
            // no default
        }
    },
    changeLocationForLoginPage: function(component) {
        if (window.location.href.indexOf('/login') !== -1) {
            var url = window.location.href;
            url = url.replace('/login', '');
            window.location.href = url;
        }
    }
})