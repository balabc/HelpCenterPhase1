({
    doInit: function(component, event, helper) {
        helper.setFilters(component);
        helper.retrieveArticles(component);
        helper.retrieveArticlesCount(component);
        var categories = component.find('currentFilter');
        $A.util.addClass(categories, 'slds-hide');
    },

    changeLocation: function(component, event, helper) {
        helper.setFilters(component);
        helper.retrieveArticles(component);
        helper.retrieveArticlesCount(component);
    },

    changePage: function(component, event, helper) {
        helper.changePage(component, event.getParam('direction'));
    }
})