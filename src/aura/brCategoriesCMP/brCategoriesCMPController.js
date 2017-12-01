({
	doInit : function(component, event, helper) {
        var data = component.get("v.data");
        if (!!data) {
            component.set('v.selectedArticleId', data.recordId);
        } else {
            data = {
                dataCategory: 'Public', 
                objectName: 'Public__kav'
            };
        }
        	
        component.set("v.data", data);
        helper.getResponse(component);
	},
    clickCategory: function(component, event, helper) {    
        var parent = event.target.parentElement,
        	active = parent.getAttribute('data-active'),
            allChildOff = function(_parent) {
                var items = _parent.getElementsByTagName('li');
                for (var i = 0; i < items.length; i++) {
                    items.item(i).setAttribute('data-active', false)
                    items.item(i).classList.remove('active');
                }
            };  
        if (active != 'true') {
            allChildOff(parent);
            
            parent.setAttribute('data-active', true);
            parent.classList.add('active');
        } else {
            parent.setAttribute('data-active', false);
            parent.classList.remove('active');
        }
        //parent.setAttribute('data-active', ((active == 'true')? false: true));
    },
    clickElement: function(component, event, helper) {    
        var parent = event.target.parentElement,
            active = parent.getAttribute('data-active'),
            items = document.getElementsByClassName("article"),
            navEvt = $A.get("e.force:navigateToSObject");
        
        for (var i = 0; i < items.length; i++) {
            items.item(i).parentElement.setAttribute('data-active', false)
            items.item(i).classList.remove('active'); 
        }
        
        if (active != 'true') {
            parent.setAttribute('data-active', true);
            parent.classList.add('active');
        } else {
            parent.setAttribute('data-active', false);
            parent.classList.remove('active');
        }     
        
        navEvt.setParams({
          "recordId": parent.getAttribute('data-id')
        });
        navEvt.fire();
    }
})