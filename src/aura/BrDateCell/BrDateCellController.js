({
	handleClick : function(component) {
		var click = component.getEvent("dateCellClick");
		click.setParams({"class": component.get("v.tdClass")});
		click.fire();
	}
})