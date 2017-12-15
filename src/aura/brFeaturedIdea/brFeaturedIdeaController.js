
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
    doInit : function(component, event, helper) {
        //console.log('Featured Idea');
        if(typeof $A.get("$SfdcSite") !== 'undefined'){
            try{
	            var communityPrefix = $A.get("$SfdcSite").pathPrefix;
                var host = window.location.host;
                component.set('v.loginURL', 'https://' + host + communityPrefix + '/s/login/');
            }catch(ee){
                console.log('tryE:', ee);
            }
	        //console.log('communityPrefix:'+communityPrefix);
	    }
        helper.getComponentData(component);
    }
})