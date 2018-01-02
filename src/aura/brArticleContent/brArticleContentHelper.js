({
	getDataForArticle: function(component) {
		var action = component.get("c.getDataForArticle"),
            articleId = component.get('v.recordId');

		action.setStorable();

        action.setParams({
            'articleId': articleId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
               //console.log(data);
                component.set("v.articleType", data.articleType);
                component.set("v.dataCategory", data.dataCategory);
                
                var brCategoriesCMP = component.find('brCategoriesCMP');
                if (!!brCategoriesCMP) {
                    brCategoriesCMP.set('v.data', {
                        id: articleId,
                        objectName: data.articleType,
                        dataCategory: data.dataCategory
                    });
                    brCategoriesCMP.changeData();
                }
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
	},

    getArticle: function(component) {
		var action = component.get("c.getArticleContent");

        action.setParams({
            'articleId': component.get('v.recordId')
        });

        action.setStorable();

        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.article", data);
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
	}
})