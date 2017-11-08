({
	doInit : function(component, event, helper) {
        var data;
        data = {'ids': component.get('v.idsPopular')};
        helper.getData(component, 'v.listPopular', 'c.getChatterGroupByStringId', data);
        helper.getData(component, 'v.listQuestions', 'c.getQuestions', false);
        helper.getData(component, 'v.listNews', 'c.getBlogArticles', false);
	},
    navigateToArticle : function (component, event, helper) {
        console.log(event);
        var target = event.target,
            id = target.getAttribute('data-id'),
            navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id
        });
        navEvt.fire();
    }
})