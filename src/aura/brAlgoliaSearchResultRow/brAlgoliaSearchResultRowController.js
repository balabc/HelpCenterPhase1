({
    onClickObject: function(component, event, helper) {
        var id = component.get('v.item').source.objectID;
       //console.log(id);
        helper.changeLocation(component, 'SalesforceObject', id);
    }
})