({
	doInit : function(component, event, helper) {
        var data;
        data = {'ids': component.get('v.idsPopular')};
        helper.getData(component, 'v.listPopular', 'c.getChatterGroupByStringId', data);
        helper.getData(component, 'v.listQuestions', 'c.getQuestions', false);
        if (component.get('v.isShowGroupPosts')) {
            helper.getData(component, 'v.listGroupPosts', 'c.getGroupPosts', {'id': component.get('v.groupId')});
        } else {
            helper.getData(component, 'v.listNews', 'c.getBlogArticles', false);
        }
        
        //00B0O000009JuTYUA0
        helper.getData(component, 'v.idListGroup', 'c.getChatterGroupListId', false);
	},
    navigateTosObject : function (component, event, helper) {
        console.log(event);
        var target = event.target.closest('li'),
            id = target.getAttribute('data-id'),
            navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id
        });
        navEvt.fire();
    },
    navigateToListGroup : function (component, event, helper) {
        var target = event.target,
            id = target.getAttribute('data-id'),
            navEvent = $A.get("e.force:navigateToList");
        navEvent.setParams({
            "listViewId": id,
            "listViewName": null,
            "scope": "CollaborationGroup"
        });
        navEvent.fire();
    },
   	navigateToUrl : function (component, event, helper) {
        var target = event.target,
            url = target.getAttribute('data-url'),
            navEvent = $A.get("e.force:navigateToURL");
        navEvent.setParams({
          "url": url
        });
        navEvent.fire();
        
    }
})