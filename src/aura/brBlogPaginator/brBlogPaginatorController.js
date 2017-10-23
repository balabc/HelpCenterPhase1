({
    openPreviousPage: function(component) {
        var navEvent = component.getEvent('blogChangePageEvent');
        navEvent.setParam('direction', 'prev');
        navEvent.fire();
    },

    openNextPage: function(component) {
        var navEvent = component.getEvent('blogChangePageEvent');
        navEvent.setParam('direction', 'next');
        navEvent.fire();
    },

    doInit: function(component, event, helper) {
        component.set("v.isVisibleBtnNext", true);
    }
})