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
        var toggleDropdown = document.getElementById('userMenu');
        var arrow = document.getElementById('arrow');
        $A.util.toggleClass(toggleDropdown, "toggle");
        $A.util.toggleClass(arrow, "nav-arrow--up");

        if (!document.getElementById('userMenu').classList.contains('toggle')) {
            helper.setUserMenuItems(cmp);
            helper.getReputationPoints(cmp);
            helper.getReputationLevel(cmp);
        }
    }
})