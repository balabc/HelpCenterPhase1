({
    doInit : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                component.set('v.isReady', true);
            }), 1000
        );

        var windowHeight = document.documentElement.clientHeight - 347;
        component.set('v.windowHeight', windowHeight);
        component.set('v.search', '');
    },
    closeUserMenu: function (cmp, event, helper) {
        var userDropDownMenu = document.getElementById('userDropDownMenu'),
            isOpenUserMenu = true;

        if (!$A.util.isUndefinedOrNull(userDropDownMenu) && !$A.util.isEmpty(userDropDownMenu)) {
            for (var j = 0; j < userDropDownMenu.classList.length; j++) {
                if (userDropDownMenu.classList[j] === 'toggle') {
                    isOpenUserMenu = false;
                }
            }
            if (isOpenUserMenu && !$A.util.isUndefinedOrNull(event.target) && !$A.util.isUndefinedOrNull(event.target.classList)) {
                var className = event.target.getAttribute('class');
                var userDropDownMenuChildren = userDropDownMenu.getElementsByTagName("*"),
                    wrapUserPicClasses = document.getElementById('wrapUserPic').getElementsByTagName("*"),
                    childExist = true,
                    allClasses = [];

                for (var k = 0; k < userDropDownMenuChildren.length; k++) {
                    allClasses.push(userDropDownMenuChildren[k].getAttribute('class'));
                }

                for (var l = 0; l < wrapUserPicClasses.length; l++) {
                    allClasses.push(wrapUserPicClasses[l].getAttribute('class'));
                }

                for (var i = 0; i < allClasses.length; i++) {
                    if (allClasses[i] !== className) {
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

        var target = event.target,
            flag = true,
            classes = [
                'header__wrap-nav',
                'header-mobile__nav',
                'header-mobile__menu-icon'
            ];

        if (!$A.util.isUndefinedOrNull(target) && !$A.util.isEmpty(target) && (typeof target.closest !== "undefined")) {
            for (var c in classes) {
                var clos = target.closest('.' + classes[c]);

                if (!$A.util.isUndefinedOrNull(clos) && !$A.util.isEmpty(clos)) {
                    flag = false;
                } else if (target.className.indexOf(classes[c]) > -1) {
                    flag = false;
                }
            }

            if (flag) {
                var toggleSearchModal = $A.get("e.c:brCloseAllNavMenuEvent");
                toggleSearchModal.fire();
            }
        }
    },
    toggleSearchModal : function(component, event, helper) {
        var toggleSearchModal = $A.get("e.c:brToggleSearchModalEvent");
        toggleSearchModal.fire();
    },
    changeSearch : function(component, event, helper) {
        var search = event.getParam("search");
        component.set('v.search', search);
    }
})