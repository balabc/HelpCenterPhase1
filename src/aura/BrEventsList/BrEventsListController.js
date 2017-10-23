({
    doInit: function(cmp, event, helper){
        var dateFilter = cmp.get('v.dateFilter');

        helper.resetFilters(cmp);

        if(dateFilter && dateFilter !== ''){
            cmp.set('v.filters.date', dateFilter);
        }

        helper.retrieveItems(cmp, function(){
            helper.retrievePagesTotal(cmp);
        });

    },
    openNextPage: function(cmp, event, helper) {
        var p = cmp.get('v.currentPage'),
            pagesTotal = cmp.get('v.pagesTotal');

        if (p < pagesTotal) {
            cmp.set('v.currentPage', p + 1);
            helper.retrieveItems(cmp);
            helper.scrollToTop();
        }
    },
    openPreviousPage: function(cmp, event, helper) {
        var p = cmp.get('v.currentPage');

        if (p > 1) {
            cmp.set('v.currentPage', p - 1);
            helper.retrieveItems(cmp);
            helper.scrollToTop();
        }
    },
    searchEvents: function(cmp, event, helper) {
        var query = cmp.get('v.searchQuery');

        helper.resetFilters(cmp);
        helper.toggleTabs(cmp, 'All');
        cmp.set('v.filters.search', query);

        helper.resetPaginationControlls(cmp);
        helper.retrieveItems(cmp, function(){
            helper.retrievePagesTotal(cmp);
        });
    },

    selectTab: function(cmp, event, helper) {
        var targetEl = event.currentTarget,
            tabValue = targetEl.dataset.target;

            helper.resetFilters(cmp);
            cmp.set('v.searchQuery', '');
            cmp.set('v.filters.tab', tabValue);
            helper.toggleTabs(cmp, tabValue);

        helper.resetPaginationControlls(cmp);
        helper.retrieveItems(cmp, function(){
            helper.retrievePagesTotal(cmp);
        });
    },

    refreshCalendar: function(cmp) {

        var datepicker = cmp.find('datepicker');
        datepicker.refreshCalendar();
    },

    retrieveItemsForDate: function(cmp, event, helper) {
        helper.toggleTabs(cmp, 'All');
        helper.resetFilters(cmp);

        cmp.set('v.filters.date', event.getParam('value'));

        helper.resetPaginationControlls(cmp);
        helper.retrieveItems(cmp, function(){
            helper.retrievePagesTotal(cmp);
        });
    }
})