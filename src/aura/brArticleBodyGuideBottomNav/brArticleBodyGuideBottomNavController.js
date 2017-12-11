({
    doInit : function(component, event, helper) {
        console.log(component.get('v.article'));
        helper.getData(component, 'v.listArticles', 'c.getListArticleInCurrentCategory', {
            id: component.get('v.article').id
        });
    }
})