({
    openItem: function(cmp, event) {

        var targetEl = event.currentTarget,
            itemId = targetEl.dataset.id,
            isCommunity = cmp.get('v.isCommunity');

        if(!isCommunity){
            var evt = cmp.getEvent('eventsOpenItemEvent');
            evt.setParam('itemId', itemId);
            evt.fire();
        }
    },

    rsvpItem: function(cmp, event, helper) {
        var targetEl = event.currentTarget,
            rsvpType = targetEl.dataset.type,
            errEvt;

        helper.rsvpItem(cmp, rsvpType, function(newAttendeesCount) {
            if (newAttendeesCount !== 'error' && newAttendeesCount !== 'auth_required' && newAttendeesCount !== 'limit_exceded') {

                helper.toggleGoingDropdown(cmp);
                cmp.set('v.item.attendeesCount', newAttendeesCount);
                cmp.set('v.rsvpType', rsvpType);

                var eventsRsvpEvent = cmp.getEvent("eventsRsvpEvent");
                eventsRsvpEvent.fire();

            } else if (newAttendeesCount === 'auth_required') {
                errEvt = cmp.getEvent('eventsErrorEvent');
                errEvt.setParams({'type':'auth_required', 'message':$A.get("$Label.c.msg_authorization_required")});
                errEvt.fire();
            } else if (newAttendeesCount === 'limit_exceded') {
                errEvt = cmp.getEvent('eventsErrorEvent');
                errEvt.setParams({'type':'limit_exceded', 'message':$A.get("$Label.c.msg_attendees_limit_exceded")});
                errEvt.fire();
            } else {
                //TODO: handle error
            }
        });
    },

    toggleGoingDropdown: function (cmp, event, helper) {
        helper.toggleGoingDropdown(cmp);
    }
})