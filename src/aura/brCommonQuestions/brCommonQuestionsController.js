({
    onInit: function(component, event, helper){
        var communityPrefix = '';
		if(typeof $A.get("$SfdcSite") !== 'undefined'){
           communityPrefix = $A.get("$SfdcSite").pathPrefix;
        }
        component.set('v.articleBaseURL','https://' + window.location.host + communityPrefix + '/s/');
        helper.getArticles(component);
    }
})