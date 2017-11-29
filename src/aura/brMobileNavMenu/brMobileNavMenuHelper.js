({
    getSubMenuUser: function(component, user){
        return [                       
            {id: 'profile', label: $A.get('$Label.c.lnkProfile'), type: 'SalesforceObject', target: user.id},
            {id: 'my_messages', label: $A.get('$Label.c.lnkMyMessages'), type: 'InternalLink', target: '/messages/Home'},
            {id: 'my_feed', label: $A.get('$Label.c.lnkMyFeed'), type: 'InternalLink', target: '/feed'},
            {id: 'my_cases', label: $A.get('$Label.c.lnkMyCases'), type: 'InternalLink', target: '/case'},
            {id: 'my_files', label: $A.get('$Label.c.lnkMyFiles'), type: 'InternalLink', target: '/MyFeed'},
            {id: 'settings', label: $A.get('$Label.c.lnkSettings'), type: 'InternalLink', target: '/settings/' + user.id},
            {id: 'log_out', label: $A.get('$Label.c.lnkLogOut'), type: 4, target: '/secur/logout.jsp'}
            
        ];
    },
    fillPhoneList: function(component){
        try {
            var action = component.get("c.getPhoneList");
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    component.set("v.phoneList", data);
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);

        }catch(e){
            console.log('tryE:', e);
        }
    },
    getUserInfo: function(component) {
        var action = component.get("c.getUserInfo");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {      
                component.set("v.user", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getNavigationMenu: function(component) {
        var action = component.get("c.getNavigationMenu");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {  
                component.set("v.menuItems", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    } 
})