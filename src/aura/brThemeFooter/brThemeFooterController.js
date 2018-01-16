({
    setIsReady: function (component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                component.set('v.isReady', true);
            }), 2500
        );
    }
})