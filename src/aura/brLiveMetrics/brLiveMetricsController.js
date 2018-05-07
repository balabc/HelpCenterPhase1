({
	doInit : function(component, event, helper) {

        helper.showCurrentUserName(component);

        if ($A.get("$Browser.formFactor") !== 'PHONE') {
            helper.getData(component, 'v.solutions', 'c.getFeedItemCount', false);
            helper.getData(component, 'v.members', 'c.getUserCount', false);
            helper.getData(component, 'v.ideas', 'c.getIdeaCount', false);
        }
    }
})