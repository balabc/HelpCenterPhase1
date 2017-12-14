
({
    viewIdeaClick : function(component, event, helper) {
        //console.log('viewIdeaClick');
        var ideaId = component.get('v.ideaId');
        if(typeof $A.get("$SfdcSite") !== 'undefined'){
            var host = window.location.host;
            var communityPrefix = $A.get("$SfdcSite").pathPrefix;
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": 'https://' + host + communityPrefix + '/s/ideas#' + ideaId//TODO: clarify right way for this cuz current kinda hardcode?
            });
            urlEvent.fire();
        }
    },
    logInClick : function(component, event, helper) {
        //console.log('logInClick');
        if(typeof $A.get("$SfdcSite") !== 'undefined'){
            var host = window.location.host;
            var communityPrefix = $A.get("$SfdcSite").pathPrefix;
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": 'https://' + host + communityPrefix + '/s/login/'//TODO: clarify right way for this
            });
            urlEvent.fire();
        }
    },
    doInit : function(component, event, helper) {
        //console.log('Featured Idea');
        if(typeof $A.get("$SfdcSite") !== 'undefined'){
	        var communityPrefix = $A.get("$SfdcSite").pathPrefix;

	        console.log('communityPrefix:'+communityPrefix);
	    }
        helper.getComponentData(component);
    }
})