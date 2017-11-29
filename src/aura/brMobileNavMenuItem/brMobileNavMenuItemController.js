({
    onClick : function(component, event, helper) {
        var link = event.target.closest('.header-mobile__menu-link'),
            type = link.getAttribute('data-type'),
            data = link.getAttribute('data-target'),
            id = link.dataset.menuItemId,
            urlEvent;
        
        switch (type) {
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
        }
    },
    onChangeLvl: function(component, event, helper) {
        var li = event.target.closest('.header-mobile__menu-item');
        
        helper.changeMobileMenuLvl(component, {
            id: li.getAttribute('data-id'),
            title: li.getAttribute('data-title'),
            where: li.getAttribute('data-where')
        });
    }
})