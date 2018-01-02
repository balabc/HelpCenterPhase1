({
    showCurrentUser: function (cmp, event) {
        var action = cmp.get('c.getCurrentUser');
        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState(),
                user = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.user', user);
            } else if (state === "ERROR") {
                //console.log('callback error: getCurrentUser in brUserMenu.js');
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message === 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    getTypeForCurrentUser: function (cmp, callback) {
        var action = cmp.get('c.getUserType');
        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState(),
                type = response.getReturnValue();

            if (state === 'SUCCESS') {
                if (typeof callback === 'function') {
                    callback(type);
                }
            } else if (state === "ERROR") {
                //console.log('callback error: getUserType in brUserMenu.js');
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message === 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    setUserMenuItems: function (cmp, event) {
        var action = cmp.get('c.getUserMenuItems');
        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState(),
                menuItems = response.getReturnValue();

            if (state === 'SUCCESS') {
                var menuItemsJSON = JSON.parse(menuItems);
                cmp.set('v.menuItems', menuItemsJSON);
            } else if (state === "ERROR") {
               //console.log('callback error: setUserMenuItems in brUserMenu.js');
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message === 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    getReputationPoints: function (cmp, event) {
        var action = cmp.get('c.getUserReputationPoints');
        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState(),
                reputationPoints = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.reputationPoints', reputationPoints);
            } else if (state === "ERROR") {
                //console.log('callback error: getReputationPoints in brUserMenu.js');
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message === 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    getReputationLevel: function (cmp, event) {
        var action = cmp.get('c.getUserReputationLevel');
        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState(),
                reputationLevel = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.reputationLevel', reputationLevel);
            } else if (state === "ERROR") {
                //console.log('callback error: getReputationLevel in brUserMenu.js');
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message === 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    }
})