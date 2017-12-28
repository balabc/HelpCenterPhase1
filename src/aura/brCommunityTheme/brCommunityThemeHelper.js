({
    loadUserInfo: function (cmp) {
        var action = cmp.get('c.getUserInfo');

        action.setCallback(this, function(response) {
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === 'SUCCESS') {
                window.CommunityDataCache.setData('userInfo', resVal);
                console.log(window.CommunityDataCache.getData('userInfo'));
            }
        });

        $A.enqueueAction(action);
    }
})