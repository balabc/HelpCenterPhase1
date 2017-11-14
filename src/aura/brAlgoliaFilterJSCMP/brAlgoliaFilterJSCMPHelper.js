({
	toChangeFilter : function(component) {
		var changeFilter = component.getEvent("eventFromBrAlgoliaFilter"),
            currentFilter = component.get("v.currentFilter"),
            filter = component.get("v.brFilter");
        changeFilter.setParams({
            "brFilter" : {
                type: currentFilter,
                values: filter[currentFilter]
            }
        });
        changeFilter.fire();
	}
})