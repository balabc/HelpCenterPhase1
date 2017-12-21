({
    closeUserMenu: function (cmp, event, helper) {
        var userDropDownMenu = document.getElementById('userDropDownMenu'),
            isOpenUserMenu = true;

        for (var j = 0; j < userDropDownMenu.classList.length; j++) {
            if (userDropDownMenu.classList[j] == 'toggle') {
                isOpenUserMenu = false;
            }
        }

        if (isOpenUserMenu) {
            var className = event.target.getAttribute('class');
            var userDropDownMenuChildren = userDropDownMenu.getElementsByTagName("*"),
                wrapUserPicClasses =  document.getElementById('wrapUserPic').getElementsByTagName("*"),
                childExist = true,
                allClasses = [];

            for (var k = 0; k < userDropDownMenuChildren.length; k++) {
                allClasses.push(userDropDownMenuChildren[k].getAttribute('class'));
            }

            for (var l = 0; l < wrapUserPicClasses.length; l++) {
                allClasses.push(wrapUserPicClasses[l].getAttribute('class'));
            }

            for (var i = 0; i < allClasses.length; i++) {
                if (allClasses[i] != className) {
                    childExist = false;
                }
                else {
                    childExist = true;
                    break;
                }
            }

            if (!childExist) {
                var userMenu = document.getElementById('userMenu');
                var arrow = document.getElementById('arrow');
                $A.util.removeClass(arrow, "nav-arrow--up");
                $A.util.addClass(userMenu, "toggle");
            }
        }
    }
})