({
    getArticles: function(component) {
        try {
            var action = component.get("c.getArticles");
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var articlesList = response.getReturnValue();
                    component.set("v.articlesList", articlesList);
                    component.set("v.articlesCount", articlesList.length);
                } else if (state === "ERROR") {
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

        } catch (e) {
            console.log('tryE:', e);
        }
    }
})