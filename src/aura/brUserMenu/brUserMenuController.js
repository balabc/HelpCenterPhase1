({
    doInit: function (cmp, event, helper) {
        helper.getTypeForCurrentUser(cmp, function(type){
            if (type === 'Guest') {
                cmp.set('v.type', 'Guest');
                document.getElementsByClassName('header__right')[0].style.paddingRight = '40px';
            } else {
                helper.showCurrentUser(cmp);
                cmp.set('v.type', 'Standard');
                helper.setUserMenuItems(cmp);
                helper.getReputationPoints(cmp);
                helper.getReputationLevel(cmp);
            }
        });
    },

    toggleDropdownMenu: function () {
        $A.util.toggleClass(document.getElementById('userMenu'), "toggle");
        $A.util.toggleClass(document.getElementById('arrow'), "nav-arrow--up");
    }
})