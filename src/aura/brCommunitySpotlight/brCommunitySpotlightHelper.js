({
    getUserInfo: function(component) {
        var action = component.get('c.getUserInfo'),
            currentId = component.get('v.curId');

        if (!!currentId) {
            action.setParams({
                'userId': currentId
            });
        }

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var user = response.getReturnValue();
                component.set("v.user", user);
                console.log(user);
            }
        });
        $A.enqueueAction(action);
    },
    changeLocation: function(component, type, data) {
        var urlEvent;

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
        }
    }
})