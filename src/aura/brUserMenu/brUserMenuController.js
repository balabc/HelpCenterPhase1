({
    doInit: function (cmp, event, helper) {
        helper.getTypeForCurrentUser(cmp, function(type){

            if (type == 'Guest') {
                cmp.set('v.type', 'Guest');
            } else {
                helper.showCurrentUser(cmp);
                cmp.set('v.type', 'Standard');
            }
        });
    },

    toggleDropdownMenu: function (cmp, event, helper) {
        var toggleDropdown = cmp.find("dropdownMenu");
        $A.util.toggleClass(toggleDropdown, "toggle");

        if (!$A.util.hasClass(toggleDropdown, "toggle")) {
            helper.setUserMenuItems(cmp);
            helper.getReputationPoints(cmp);
            helper.getReputationLevel(cmp);
        }
    }
})