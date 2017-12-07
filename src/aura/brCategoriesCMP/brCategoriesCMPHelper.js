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
            }
        });
        $A.enqueueAction(action);
    },
    getResponse: function(component) {
        var action = component.get("c.getCatalog"), 
            selectId = component.get('v.selectedArticleId'),
            articleType = component.get('v.data.objectName'),
            dataCategoryName = component.get('v.data.dataCategory');
        
        if (!!selectId) { 
            console.log(selectId, articleType, dataCategoryName);
            action.setParams({ 
                selectId : selectId,
                articleType: articleType,
                dataCategoryName: dataCategoryName
            });
        } else {
            action.setParams({ 
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
            } else {
                console.log(response);
            }
        });
        $A.enqueueAction(action);
    }
})