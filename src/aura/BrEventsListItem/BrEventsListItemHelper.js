({

    rsvpItem: function(cmp, rsvpType, callback) {

        var action = cmp.get('c.rsvpEvent');

        action.setParams({
            recordId: cmp.get('v.item.item.Id'),
            rsvpType: rsvpType,
            attendeesLimit: cmp.get('v.item.item.Limit_of_attendees__c')
        });

        action.setCallback(this, function(response){
            var state = response.getState(),
                resVal = response.getReturnValue();


            if (state === 'SUCCESS') {
                if (typeof callback === 'function') {
                    callback(resVal);
                }
            }
        });

        $A.enqueueAction(action);
    },

    toggleGoingDropdown: function (cmp) {
        var goingBtn = cmp.find('dropdown-wrapper-going');
        $A.util.toggleClass(goingBtn, 'slds-is-open');
    }
})