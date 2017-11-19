({
    onClick : function(component, event) {
        var id = event.target.dataset.menuItemId;
        if (id) {
            component.getSuper().navigate(id);
        }
    }
})