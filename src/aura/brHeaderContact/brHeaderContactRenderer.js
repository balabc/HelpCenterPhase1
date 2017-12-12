({
    afterRender: function (component, helper) {
        this.superAfterRender();
        if (window.location.hash == '#contact') {
            component.showMe();
        }
    }
})