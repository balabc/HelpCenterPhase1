({
    getArticles: function(component) {
        try {
            var action = component.get("c.getArticles");
            action.setParams({"countArticles": component.get('v.articlesCount')});
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var articlesList = response.getReturnValue();
                    component.set("v.articlesList", articlesList);
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