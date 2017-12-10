({
	getDataForArticle: function(component) {
		var action = component.get("c.getDataForArticle"),
            articleId = component.get('v.recordId');
        
        action.setParams({
            'articleId': articleId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log(data);
                component.set("v.articleType", data.articleType);
                component.set("v.dataCategory", data.dataCategory);
                
                var brCategoriesCMP = component.find('brCategoriesCMP')
                brCategoriesCMP.set('v.data', {
                    id: articleId,
                    objectName: data.articleType,
                    dataCategory: data.dataCategory
                });
                brCategoriesCMP.changeData();
            }
        });
        $A.enqueueAction(action);
	},

    getArticle: function(component) {
		var action = component.get("c.getArticleContent");

        action.setParams({
            'articleId': component.get('v.recordId')
        });

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.article", data);
            }
        });
        $A.enqueueAction(action);
	}
})