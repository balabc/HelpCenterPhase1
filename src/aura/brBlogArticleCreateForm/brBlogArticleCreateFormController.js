({
    doInit: function(component, event, helper) {
        helper.allowAddArticles(component);
    },

    showModal: function(component, event, helper) {
        helper.getAllCategories(component);
        component.set('v.isModalOpen', true);
    },

    hideModal: function(component) {
        component.set('v.isModalOpen', false);
    },

    validateShortBody: function(component, event, helper) {
        var inputCmp = component.find("shortBody");
        helper.showError(inputCmp);
    },

    validateBody: function(component, event, helper) {
        var inputCmp = component.find("body");
        helper.showError(inputCmp);
    },

    saveNewArticle: function(component, event, helper) {
        helper.addNewArticle(component);
    }
})