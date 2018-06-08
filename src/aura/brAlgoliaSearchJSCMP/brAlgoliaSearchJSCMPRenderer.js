({
    afterRender: function (component, helper) {
        this.superAfterRender();
        component.find('algolia-search-input').focus();
    }
})