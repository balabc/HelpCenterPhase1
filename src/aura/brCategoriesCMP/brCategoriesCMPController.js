({
	doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set('v.selectedArticleId', recordId);
        helper.getResponse(component, document.getElementById('menu-articles'));
	},
    clickCategory: function(component, event, helper) {    
        var parent = event.target.parentElement,
        	active = parent.getAttribute('data-active'),
            allChildOff = function(_parent) {
                var items = _parent.getElementsByTagName('li');
                for (var i = 0; i < items.length; i++) {
                    items.item(i).setAttribute('data-active', false)
                }
            };  
        if (active != 'true') {
            allChildOff(parent);
        }
        parent.setAttribute('data-active', ((active == 'true')? false: true));
    },
    clickElement: function(component, event, helper) {    
        var parent = event.target.parentElement,
            active = parent.getAttribute('data-active'),
            items = document.getElementsByClassName("article"),
            navEvt = $A.get("e.force:navigateToSObject");
        for (var i = 0; i < items.length; i++) {
            items.item(i).parentElement.setAttribute('data-active', false)
        }
        
        parent.setAttribute('data-active', ((active == 'true')? false: true));       
        
        navEvt.setParams({
          "recordId": parent.getAttribute('data-id')
        });
        navEvt.fire();
    }
})