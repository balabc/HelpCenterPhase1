({
    init : function(component, event, helper) {//console.log('live init component');
        function liveAgentStart(){
            //timeout to initiate liveAgent
            window.setTimeout(
                $A.getCallback(function() {
                    if (component.isValid()) {
                        var data = {};
                        data.LA_chatServerURL =component.get("v.endpoint");
                        data.LA_deploymentId =component.get("v.deploymentId");
                        data.organizationId =component.get("v.organizationId");
                        data.chatButtontId =component.get("v.chatButtontId");
                        data.userSessionData =component.get("v.userSessionData");
                        if (component.get("v.contact") != null){
                            data.contactId =component.get("v.contact").Id;
                            data.contactName =component.get("v.contact").Name;
                        }
                        function initLiveAgent (data){
                            var self = this;
                            self.data = data;

                            if ((typeof liveagent == "object") && (document.getElementById('btONline') != null )){
                                clearInterval(interV);
                                helper.bindLiveAgent(component,data);
                            }//else{console.log('CTRL  timeout to init live agent');}
                        }
                        //setInterval to initiate liveAgent when liveagent object
                        // is available
                        interV = setInterval(initLiveAgent,500,data);
                    }//else{console.log('CTRL  component is not valid');}
                }), 500
            );
        }

        var isValid = helper.validateComponent(component);
        component.set("v.isInvalidInput", !isValid);
        if ( isValid){
            if ( component.get("v.userSessionData") == true){//console.log('ask Contact');
                //retrieve logged user Contact Details
        		var action = component.get("c.getContact");
        		action.setCallback(this, function(a) {
                    component.set("v.contact", a.getReturnValue());
                    liveAgentStart();
        		});
        		$A.enqueueAction(action);
            }else {//console.log('dont ask contact');
                liveAgentStart();
            }

            var chatBtn = component.get("v.chatButtontId")+'';
            //adding liveAgent buttons wo global array
            if (!window._laq) { window._laq = []; }
            window._laq.push(function(){
                liveagent.showWhenOnline(
                    (function (chatBtn) {//console.log('showWhenOnline');
                            return chatBtn;
                        })(chatBtn)
                    , document.getElementById('btONline'));
                liveagent.showWhenOffline(
                    (function (chatBtn) {//console.log('showWhenOffline');
                            return chatBtn;
                        })(chatBtn)
                    , document.getElementById('btOFFline'));
            });
        }//else{console.log('on init is Not Valid');}

    },

    startChat : function(component, event, helper) {
        liveagent.startChat(component.get("v.chatButtontId"));
    }
})