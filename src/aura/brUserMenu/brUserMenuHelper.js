({
    getCurrentUser: function (cmp, event) {
        var action = cmp.get('c.getCurrentUser');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                user = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.user', user);
                console.log('type: ' + user.UserType);
            } else {
                console.log('callback error: getCurrentUser in brUserMenu.js');
            }
        });

        $A.enqueueAction(action);
    },

    setUserMenuItems: function (cmp, event) {
        var action = cmp.get('c.getUserMenuItems');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                menuItems = response.getReturnValue();

            if (state === 'SUCCESS') {
                var menuItemsJSON = JSON.parse(menuItems);
                cmp.set('v.menuItems', menuItemsJSON);
            } else {
                console.log('callback error: setUserMenuItems in brUserMenu.js');
            }
        });

        $A.enqueueAction(action);
    },

    getReputationPoints: function (cmp, event) {
        var action = cmp.get('c.getUserReputationPoints');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                reputationPoints = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.reputationPoints', reputationPoints);
            } else {
                console.log('callback error: getReputationPoints in brUserMenu.js');
            }
        });

        $A.enqueueAction(action);
    },

    getReputationLevel: function (cmp, event) {
        var action = cmp.get('c.getUserReputationLevel');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                reputationLevel = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.reputationLevel', reputationLevel);
            } else {
                console.log('callback error: getReputationLevel in brUserMenu.js');
            }
        });

        $A.enqueueAction(action);
    }
})