
({
    getComponentData : function(component){
        try {
            var action = component.get("c.getFeaturedIdeaData"),
            ideaId = component.get("v.ideaId");

            action.setParams({
                ideaId: ideaId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var componentData = response.getReturnValue();
                    //console.log('componentData[FeaturedIdea]:', componentData);
                    component.set("v.userId", componentData.userId);
                    component.set("v.ideaText", componentData.itemText);
                    component.set("v.ideaTitle", componentData.itemTitle);
                    component.set("v.ideaPoints", componentData.points);

                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);

        }catch(e){
            console.log('tryE:', e);
        }
    }
})