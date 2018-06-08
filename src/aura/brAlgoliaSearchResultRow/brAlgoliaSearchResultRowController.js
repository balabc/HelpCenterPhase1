({
    onClickObject: function(component, event, helper) {
        helper.changeLocation(
            component,
            'InternalLink',
            component.get('v.item').source.url
        );
        $A.get("e.c:brCloseSearchModalEvent").fire();
    }
})