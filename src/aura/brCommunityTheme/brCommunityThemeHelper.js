({
    loadUserInfo: function (cmp) {
        var action = cmp.get('c.getUserInfo');

        action.setStorable();

        action.setCallback(this, function(response) {
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === 'SUCCESS') {
                window.CommunityDataCache.setData('userInfo', resVal);
               //console.log(window.CommunityDataCache.getData('userInfo'));
            }
        });

        $A.enqueueAction(action);
    },
    showAnnouncement: function (component) {
        var action = component.get('c.getAnnouncement');

        action.setCallback(this, function(response) {
            var state = response.getState(),
                message = response.getReturnValue();

            if (state === 'SUCCESS') {
                if (message !== null) {
                    component.set('v.announcementMessage', message);
                    component.set('v.showNotification', true);
                } else {
                    component.set('v.showNotification', false);
                }
            }
        });

        $A.enqueueAction(action);
    }
})