({
	doInit : function(component, event, helper) {

        helper.getData(component, 'v.solutions', 'c.getFeedItemCount', false);
        helper.getData(component, 'v.members', 'c.getUserCount', false);
        helper.getData(component, 'v.ideas', 'c.getIdeaCount', false);
        helper.getTypeForCurrentUser(component, function(type) {
            if (type === 'Guest') {
                component.set('v.type', 'Guest');
            } else {
                helper.showCurrentUserName(component);
            }
        });

    }
})