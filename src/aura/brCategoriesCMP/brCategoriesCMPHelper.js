({
    getResponse: function(component) {
        var action = component.get("c.getCatalog"),
            selectId = component.get('v.selectedArticleId'),
            articleType = component.get('v.articleType'),
            dataCategoryName = component.get('v.dataCategoryName');
        if (!!selectId) { 
            console.log(selectId, articleType, dataCategoryName);
            action.setParams({ 
                selectId : selectId,
                articleType: articleType,
                dataCategoryName: dataCategoryName
            });
        }
               
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('res',res);
                component.set("v.items", res);
            }
        });
        $A.enqueueAction(action);
    }
})