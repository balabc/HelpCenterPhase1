
({
	init : function(component, event, helper) {
        $A.createComponent("ltng:require", {
            scripts: [component.get("v.paramURL")]
        }, function(ltngRequire) {
            component.set("v.body", [ltngRequire])
        });
	}
})