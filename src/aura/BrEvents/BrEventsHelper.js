({
    init: function(cmp){
        var urlVars,
            environmentType = cmp.get('v.environmentType');

        if(environmentType === 'Community'){
            urlVars = this.parseQueryVars();

            if (urlVars.id) {
                cmp.set('v.itemId', urlVars.id);
                cmp.set('v.view', 'item');
            } else {
                if(urlVars.date){
                    cmp.set('v.dateFilter', urlVars.date);
                    history.pushState({}, document.title, location.pathname);
                }
                cmp.set('v.view', 'list');
            }
        } else {
            cmp.set('v.isCommunity', false);
            cmp.set('v.view', 'list');
        }
    },

    retrieveUserInfo: function(cmp) {
        var action = cmp.get('c.getUserInfo');

        action.setCallback(this, function(response) {
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.userInfo', resVal);
            }
        });

        $A.enqueueAction(action);
    },

    parseQueryVars: function() {
        var varsObj = {},
            queryVarsArr = [],
            keyVal = [];

        if (typeof location.hash !== "undefined" && location.hash && location.hash.length > 0) {
            queryVarsArr = location.hash.replace('#/', '').replace('#', '').split('&');
        } else if (typeof location.search !== "undefined" && location.search && location.search.length > 0) {
            queryVarsArr = location.search.replace('?', '').split('&');
        }

        for (var i = 0; i < queryVarsArr.length; i+=1) {
            keyVal = queryVarsArr[i].split("=");

            if (keyVal.length === 2) {
                varsObj[keyVal[0]] = keyVal[1];
            } else if (i === 0 && keyVal.length === 1) {
                varsObj.id = keyVal[0];
            }
        }

        return varsObj;
    }
})