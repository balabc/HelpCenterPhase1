({
    showAnnouncement: function (component) {
        var action = component.get('c.getAnnouncement');

        action.setStorable();
        action.setBackground();

        action.setCallback(this, function(response) {
            var state = response.getState(),
                res = response.getReturnValue();

            if (state === 'SUCCESS') {
                if (res !== null) {
                    res.QualifiedApiName = res.QualifiedApiName.toLowerCase();
                    component.set('v.notice', res);
                    component.set('v.showNotification', true);
                } else {
                    component.set('v.showNotification', false);
                }
            }
        });

        $A.enqueueAction(action);
    }
})