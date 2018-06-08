({
    doInit : function(component, event, helper) {
        component.set('v.routeInputForGroup', {recordId: component.get('v.groupId')});
    },
    openPage: function (cmp, event, helper) {
        if (event.target.hasAttribute("href")) {
            event.target.removeAttribute("href");
        }

        var urlEvent = $A.get("e.force:navigateToURL"),
            findClass = event.target;

        while (findClass.getAttribute('class') !== 'panel-media' && findClass.getAttribute('class') !== 'panel-media p-media') {
            findClass = findClass.parentNode;
        }

        var url = findClass.getAttribute('id');

        if (url === 'groups') {
            helper.gotoList(cmp);
        } else if (url === 'userDocs') {
            url = cmp.get('v.userDocsUrl');
        } else if (url === 'devDocs') {
            url = cmp.get('v.devDocsUrl');
        } else {
            url = '/' + url;
        }

        if (url !== 'groups') {
            urlEvent.setParams({"url": url}).fire();
        }
    },
    navigateToGroup : function (component, event, helper) {
        var id = component.get('v.groupId'),
            navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id
        });
        navEvt.fire();
    }
})