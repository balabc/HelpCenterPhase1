({
    onRender: function (cmp,event, helper) {
        helper.onRender(cmp);
    },
    openModal: function (cmp,event, helper) {
        cmp.set('v.isModalOpen', true);
        helper.getReasons(cmp);
    },
    saveNegativeFeedback: function (cmp,event, helper) {
        var reason = cmp.find('reason'),
            reasonValue = reason.get("v.value");

        if (reasonValue === '--None--' || reasonValue === '' || reasonValue === undefined) {
            reason.set("v.errors", [{message:"Please choose reason!"}]);
        } else {
            reason.set("v.errors", [{message:""}]);
            helper.addNegativeFeedback(cmp);
            cmp.set('v.isModalOpen', false);
        }
    },
    addPositiveFeedBack: function (cmp,event, helper) {
        helper.addPositiveFeedBack(cmp);
        cmp.set('v.isModalOpen', false);
    },
    hideModal: function (cmp,event, helper) {
        cmp.set('v.isModalOpen', false);
    },
    onSelectReason: function (cmp, event, helper) {
        var option = cmp.find('reason').get("v.value");

        if (option === 'Other (please specify)') {
            cmp.find('feedbackComment').getElement().style.display = 'block';
        } else {
            cmp.set('v.comment', '');
            cmp.find('feedbackComment').getElement().style.display = 'none';
        }
    }
})