/**
 * Created by lovandos on 5/7/18.
 */
({
    retrieveArticleSections: function (component, articleId) {
        var action = component.get("c.getArticleSectionsByArticle");

        action.setBackground();
        action.setStorable();

        action.setParams({
            articleId: articleId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue(),
                    data = [];

                for (var key in result) {
                    data.push({value:result[key], key:key});
                }

                component.set('v.articleSections', data);
            }
        });
        $A.enqueueAction(action);
    }
})