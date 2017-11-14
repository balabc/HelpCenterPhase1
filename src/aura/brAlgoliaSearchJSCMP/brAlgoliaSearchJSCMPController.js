({
    doInit: function(component, event, helper) { },
    searchKeyUp: function(component, event, helper) {
        var query = component.get("v.searchText");
        if (query.length >= 3) { 
            helper.getSearchResult(component);
        } else {
            component.set("v.categories", null);
            component.set("v.hasData", 'off');
        }
    },
    searchChange: function(component, event, helper) { 
        var query = component.get("v.searchText");
        if(!!query && (query.length > 0)) {
            if(query.length >= 3) {
        		helper.getSearchResult(component);
            }
        }
    },
    onChangeFilter : function(component, event, helper) {
		var filter = event.getParam("brFilter");
        component.set("v.brFilter", filter);
	},
    searchFill: function(component, event, helper) { 
        var listData = component.get("v.listData"),
            id = event.target.getAttribute('data-id');
        component.set("v.searchText", listData[id].data.name); 
        component.set("v.hasData", 'off'); 
    },
    jsLoaded: function(component, event, helper) {  }
})