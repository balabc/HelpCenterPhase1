({
    doInit: function (cmp,event, helper) {
        helper.getTypeForCurrentUser(cmp);
    },
    hasVotingCurrentUser: function(cmp, event, helper) {
        if (event.getParam("value") !== null) {
            helper.hasVotingCurrentUser(cmp);
        }
    },
    openModal: function (cmp,event, helper) {
        cmp.set('v.isModalOpen', true);
        helper.getReasons(cmp);
    },
    saveReason: function (cmp,event, helper) {
        var reason = cmp.find('reason'),
            reasonValue = reason.get("v.value");

        if (reasonValue === '--None--' || reasonValue === '' || reasonValue === undefined) {
            reason.set("v.errors", [{message:"Please choose reason!"}]);
        } else {
            reason.set("v.errors", [{message:""}]);
            helper.addVoteDownAndReason(cmp);
            cmp.set('v.isModalOpen', false);
        }
    },
    addVoteUp: function (cmp,event, helper) {
        helper.addVoteUp(cmp);
        cmp.set('v.isModalOpen', false);
    },
    hideModal: function (cmp,event, helper) {
        cmp.set('v.isModalOpen', false);
    }
})