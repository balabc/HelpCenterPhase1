({
	changeMobileMenuLvl : function(component, data) {
		var changeFilter = component.getEvent("eventMobileNavMenuItem");
        
        changeFilter.setParams({
            data: data
        });
        changeFilter.fire();
	}
})