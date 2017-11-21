({
    getCurrentUser: function (cmp, event) {
        var action = cmp.get('c.getCurrentUser');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                user = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.user', user);
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
                console.log('menuItems: ' + menuItems);
                var menuItemsJSON = JSON.parse(menuItems);
                /*for (var i=0;i<parsedJSON.length;i++) {
                    console.log('totle:' + parsedJSON[i].title);
                }*/
                cmp.set('v.menuItems', menuItemsJSON);
            } else {
                console.log('callback error: setUserMenuItems in brUserMenu.js');
            }
        });

        $A.enqueueAction(action);
    }
})