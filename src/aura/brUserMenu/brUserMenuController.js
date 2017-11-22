({
    doInit: function (cmp, event, helper) {
        helper.getCurrentUser(cmp);
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