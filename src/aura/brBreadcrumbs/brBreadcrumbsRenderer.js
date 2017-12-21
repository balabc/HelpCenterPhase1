
({
    afterRender: function (component, helper) {
        var afterRend = this.superAfterRender();
        //helper.mouseOutListener(component);
        return afterRend;
    }
})