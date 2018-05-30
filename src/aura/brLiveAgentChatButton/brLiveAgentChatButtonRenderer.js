
({
	afterRender : function(cmp, helper) {

		var ret = this.superAfterRender();
		var isValid = helper.validateComponent(cmp);

        if ( isValid){
			var onlineBtn = document.getElementById('btONline');
			var offlineBtn = document.getElementById('btOFFline');

            if( (  cmp.get("v.previousIsLiveAgentOnline")  != null ) &&
                    (cmp.get("v.previousIsLiveAgentOnline"))
					&& onlineBtn && offlineBtn ){
                	$A.util.removeClass(onlineBtn, "toggle");
	                $A.util.addClass(offlineBtn, "toggle");
            }
        }

	    return ret;

	}
})