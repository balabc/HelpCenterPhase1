({
    doInit: function(component, event, helper) {
        helper.getUserInfo(component);
    },
    onClickViewProfile: function(component, event, helper) {
        var id = event.target.closest('a').dataset.id;
        helper.changeLocation(component, 'SalesforceObject', id);
    }
})