
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

                } else if (state === "ERROR") {
                    var errors = response.getError();
                    var error_msg = '';
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            if (errors[0].message === 'access_error') {
                                error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                            } else {
                                error_msg = errors[0].message;
                            }
                        }
                    }
                    if (error_msg.length === 0) {
                        error_msg = $A.get("$Label.c.hUnknownError");
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: "sticky",
                        message: error_msg
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);

        }catch(e){
           //console.log('tryE:', e);
        }
    }
})