({
    doInit: function(cmp, event, helper){
        helper.getItem(cmp, function(){
            helper.getAttendeesCount(cmp);

            if(!cmp.get('v.hideAttendees')){
                helper.getItemParticipations(cmp);
            }
        });
    },

    rsvpItem: function(cmp, event, helper) {
        var targetEl = event.currentTarget,
            rsvpType = targetEl.dataset.type,
            errEvt;

        helper.rsvpItem(cmp, rsvpType, function(newAttendeesCount) {
            if (newAttendeesCount !== 'error' && newAttendeesCount !== 'auth_required' && newAttendeesCount !== 'limit_exceded') {

                cmp.set('v.attendeesCount', newAttendeesCount);
                helper.getItemParticipations(cmp);

                var goingBtnYesItem = cmp.find('goingBtnYesItem'),
                    goingBtnNoItem = cmp.find('goingBtnNoItem'),
                    goingBtn2YesItem = cmp.find('goingBtn2YesItem'),
                    goingBtn2NoItem = cmp.find('goingBtn2NoItem');

                if(rsvpType === 'Yes'){
                    cmp.set('v.rsvpStatus', $A.get("$Label.c.lbl_going"));
                    $A.util.addClass(goingBtnYesItem, 'slds-is-selected');
                    $A.util.removeClass(goingBtnNoItem, 'slds-is-selected');
                    $A.util.addClass(goingBtn2YesItem, 'slds-is-selected');
                    $A.util.removeClass(goingBtn2NoItem, 'slds-is-selected');
                } else if(rsvpType === 'No'){
                    cmp.set('v.rsvpStatus', $A.get("$Label.c.lbl_not_going"));
                    $A.util.addClass(goingBtnNoItem, 'slds-is-selected');
                    $A.util.removeClass(goingBtnYesItem, 'slds-is-selected');
                    $A.util.addClass(goingBtn2NoItem, 'slds-is-selected');
                    $A.util.removeClass(goingBtn2YesItem, 'slds-is-selected');
                } else{
                    cmp.set('v.rsvpStatus', $A.get("$Label.c.lbl_are_u_going"));
                }


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
        helper.toggleGoingDropdown(cmp);
    },

    toggleGoingDropdown: function (cmp, event, helper) {
        helper.toggleGoingDropdown(cmp);
    },

    openAttendeesList: function (cmp) {
        cmp.set('v.showAttendeesList', true);
    },
    openAttendeesListModal: function (cmp) {
        cmp.set('v.showAttendeesModal', true);
    },

    closeAttendeesListModal: function (cmp) {
        cmp.set('v.showAttendeesModal', false);
    },
    hideAttendeesList: function (cmp) {
        cmp.set('v.showAttendeesList', false);
    }
})