({
    showError : function(inputCmp) {
        var value = inputCmp.get("v.value");

        if (value === undefined) {
            inputCmp.set("v.valid", false);
        }

        else {
             inputCmp.set("v.valid", true);
        }
    },

    getAllCategories: function(component) {
        var action = component.get("c.getCategories");

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === 'SUCCESS') {
                component.set("v.categories", response.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    },

    allowAddArticles: function(component) {
    
        var action = component.get("c.getAllowCreateArticle");

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS") {
                component.set("v.isUserHasAccess", response.getReturnValue());
             }
        });

        $A.enqueueAction(action);
    },

    addNewArticle: function(component) {
        var nameCmp = component.find("name"),
            shortBodyCmp = component.find("shortBody"),
            bodyCmp = component.find("body"),
            selectCmp = component.find("categories"),
            selectedCategories = selectCmp.get("v.value"),
            isError = false;

        if (selectedCategories === '') {
            selectCmp.set("v.errors", [{message:""}]);
            isError = true;
        }

        else {          
                selectCmp.set("v.errors", null);
                isError = false;
        }

        if (nameCmp.get("v.value") === undefined) {
            $A.util.addClass(nameCmp, 'slds-has-error');
            isError = true;
        }

        if (shortBodyCmp.get("v.value") === undefined) {
            $A.util.addClass(shortBodyCmp, 'slds-has-error');
            isError = true;
        }

        if (bodyCmp.get("v.value") === undefined) {
            $A.util.addClass(bodyCmp, 'slds-has-error');
            isError = true;
        }

        if (isError === false) {
            $A.util.removeClass(nameCmp, 'slds-has-error');

            var article = {
                "name": nameCmp.get("v.value"),
                "shortBody": shortBodyCmp.get("v.value"),
                "body": bodyCmp.get("v.value")
            };

            var inputTagsCmp = component.find("tags"),
                tags = inputTagsCmp.get("v.value"),
                action = component.get("c.saveArticle");

            action.setParams({
            "tags": tags,
            "articleFields" : article,
            "categories" : selectedCategories
            });

            action.setCallback(this, function(response) {
                var state = response.getState();

                if (state === 'SUCCESS') {
                    var articleId = response.getReturnValue();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                    "recordId": articleId
                    });

                    navEvt.fire();               
                }

                else {
                        var message = component.find('message');
                        $A.util.removeClass(message, 'slds-hide');
                }
            });

            $A.enqueueAction(action);    
        } 
    }
})