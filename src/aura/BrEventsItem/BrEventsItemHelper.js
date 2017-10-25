({
    getItem: function (cmp, callback) {
        var action = cmp.get('c.getEvent'),
            spinner = cmp.find('spinner'),
            communityPrefix = '';

        if(typeof $A.get("$SfdcSite") !== 'undefined'){
            communityPrefix = $A.get("$SfdcSite").pathPrefix;
        }

        $A.util.removeClass(spinner, "slds-hide");

        action.setParams({
            recordId: cmp.get('v.id')
        });

        action.setCallback(this, function(response){
            var state = response.getState(),
                resVal = response.getReturnValue();


            if (state === 'SUCCESS') {
                cmp.set('v.item', resVal);

                if (resVal.item.hasOwnProperty('BR_Participations__r')) {
                    var rsvpStatus = resVal.item.BR_Participations__r[0].Participate__c,
                        goingBtnYesItem = cmp.find('goingBtnYesItem'),
                        goingBtnNoItem = cmp.find('goingBtnNoItem'),
                        goingBtn2YesItem = cmp.find('goingBtn2YesItem'),
                        goingBtn2NoItem = cmp.find('goingBtn2NoItem');

                    if (rsvpStatus === 'Yes') {
                        cmp.set('v.rsvpStatus', $A.get("$Label.c.lbl_going"));
                        $A.util.addClass(goingBtnYesItem, 'slds-is-selected');
                        $A.util.addClass(goingBtn2YesItem, 'slds-is-selected');
                    } else if (rsvpStatus === 'No') {
                        cmp.set('v.rsvpStatus', $A.get("$Label.c.lbl_not_going"));
                        $A.util.addClass(goingBtnNoItem, 'slds-is-selected');
                        $A.util.addClass(goingBtn2NoItem, 'slds-is-selected');
                    } else {
                        cmp.set('v.rsvpStatus', $A.get("$Label.c.lbl_are_u_going"));
                    }
                } else {
                    cmp.set('v.rsvpStatus', $A.get("$Label.c.lbl_are_u_going"));
                }

                var mainImageFilename = resVal.item.Main_Image_Filename__c;

                if(mainImageFilename && mainImageFilename.length > 0){
                    this.getItemMainImage(cmp, mainImageFilename, communityPrefix);
                } else{
                    cmp.set('v.itemMainImage', communityPrefix + '/resource/BrEvents/images/main-banner.jpg');
                }

                cmp.set('v.hideAttendees', resVal.item.Hide_attendees__c);
                cmp.set('v.attendeesLimit', resVal.item.Limit_of_attendees__c);
                cmp.set('v.listImageFilename', resVal.item.List_Image_Filename__c);

                if (typeof callback === 'function') {
                    callback();
                }
            }
            $A.util.addClass(spinner, "slds-hide");
        });

        $A.enqueueAction(action);
    },

    getItemParticipations: function (cmp, callback) {
        var action = cmp.get('c.getParticipations');

        action.setParams({
            recordId: cmp.get('v.id')
        });

        action.setCallback(this, function(response){
            var state = response.getState(),
                resVal = response.getReturnValue();


            if (state === 'SUCCESS') {
                cmp.set('v.itemParticipations', resVal);

                if (typeof callback === 'function') {
                    callback();
                }
            }
        });

        $A.enqueueAction(action);
    },

    getItemMainImage: function(cmp, mainImageFilename, communityPrefix){
        var action = cmp.get('c.getEventMainImage');

        action.setParams({
            recordId: cmp.get('v.id'),
            mainImageName: mainImageFilename
        });

        action.setCallback(this, function(response){
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === 'SUCCESS') {

                if(resVal !== null){
                    cmp.set('v.itemMainImage', communityPrefix + resVal);
                } else {
                    cmp.set('v.itemMainImage', communityPrefix + '/resource/BrEvents/images/main-banner.jpg');
                }
            }
        });

        $A.enqueueAction(action);
    },

    getAttendeesCount: function(cmp, callback){
        var action = cmp.get('c.getAttendeesCount');

        action.setParams({
            recordId: cmp.get('v.id')
        });

        action.setCallback(this, function(response){
            var state = response.getState(),
                resVal = response.getReturnValue();


            if (state === 'SUCCESS') {
                cmp.set('v.attendeesCount', resVal);

                if (typeof callback === 'function') {
                    callback();
                }
            }
        });

        $A.enqueueAction(action);
    },

    rsvpItem: function(cmp, rsvpType, callback) {

        var action = cmp.get('c.rsvpEvent');

        action.setParams({
            recordId: cmp.get('v.id'),
            rsvpType: rsvpType,
            attendeesLimit: cmp.get('v.attendeesLimit')
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
        var goingBtn = cmp.find('dropdown-wrapper-going'),
            goingBtn2 = cmp.find('dropdown-wrapper-going2');
        $A.util.toggleClass(goingBtn, 'slds-is-open');
        $A.util.toggleClass(goingBtn2, 'slds-is-open');
    }
})