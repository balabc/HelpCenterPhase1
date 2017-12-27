({
    getCatalogList: function(component) {
        var action = component.get("c.getCatalogList"), 
            articleType = component.get('v.data.objectName'),
            dataCategoryName = component.get('v.data.dataCategory');
        
        action.setParams({ 
            categoryName: 'All',
            articleType: articleType,
            dataCategoryName: dataCategoryName
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log(data);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message == 'access_error') {
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
    },
    getResponse: function(component) {
        var action = component.get("c.getCatalog"), 
            selectId = component.get('v.selectedArticleId'),
            articleType = component.get('v.data.objectName'),
            url = component.get('v.data.target'),
            dataCategoryName = component.get('v.data.dataCategory');

        if (!!url) {
            url = url.split('/');
            url = url[url.length - 1];
            console.log(url);
        }

        if (!!selectId) { 
            console.log(selectId, articleType, dataCategoryName);
            action.setParams({
                url: url,
                selectId : selectId,
                articleType: articleType,
                dataCategoryName: dataCategoryName
            });
        } else {
            action.setParams({
                url: url,
                articleType: articleType,
                dataCategoryName: dataCategoryName
            });
        }
               
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log(data);
                component.set("v.items", data);
            } else if (state === "ERROR") {
                //console.log(response);
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message == 'access_error') {
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
    }
})