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

        action.setStorable();
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var data = response.getReturnValue();
               //console.log(data);
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
           //console.log(url);
        }

        if (!!selectId) { 
           //console.log(selectId, articleType, dataCategoryName);
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

        action.setStorable();
               
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var data = response.getReturnValue();
               console.log(data);
                component.set("v.items", data);
            } else {
               //console.log(response);
            }
        });
        $A.enqueueAction(action);
    }
})