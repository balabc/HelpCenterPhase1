({
    doInit: function (cmp, event) {
        window.onscroll = function () {
            var cnHeader = 'header',
                cnHeaderSticky = 'header--make-sticky',
                cnSubstrate = 'header__dropdown-menu-substrate',
                cnSubstrateActive = 'header__dropdown-menu-substrate--active',
                dropdown = cmp.find('dropdown'),
                isOpenSubmenu = dropdown.getElement().classList.contains('header__dropdown-menu--active');

            if ( window.scrollY > 0 || isOpenSubmenu) {
                document.getElementsByClassName( cnHeader )[0].classList.add( cnHeaderSticky );
            } else {
                if ( !document.getElementsByClassName( cnSubstrate )[0].classList.contains( cnSubstrateActive ) ) {
                    document.getElementsByClassName( cnHeader )[0].classList.remove( cnHeaderSticky );
                }
            }
        };
    },
    onClick : function(cmp, event) {
        var id = event.target.dataset.menuItemId;
        if (id) {
            cmp.getSuper().navigate(id);
        }
    },
    toggleSubMenu: function (cmp, event, helper) {
        var themeHeader = document.getElementById("themeHeader"),
            dropdownWrap = cmp.find('dropdownWrap'),
            dropdown = cmp.find('dropdown'),
            arrow = cmp.find('arrow');

        $A.util.toggleClass(arrow, "nav-arrow--up");

        if (window.scrollY == 0) {
            if (arrow.getElement().className == 'header__nav-arrow nav-arrow') {
                $A.util.toggleClass(themeHeader, "header--make-sticky");
        } else {
                setTimeout( function () {
                    $A.util.toggleClass(themeHeader, "header--make-sticky");
                }, 600);
            }
        }

        if (arrow.getElement().className == 'header__nav-arrow nav-arrow') {
            $A.util.toggleClass(dropdownWrap, "header__wrap-dropdown-menu--active");
            window.setTimeout(
                $A.getCallback(function () {
                    $A.util.toggleClass(dropdown, "header__dropdown-menu--active");
                }), 400
            );
        } else {
            $A.util.toggleClass(dropdown, "header__dropdown-menu--active");
            window.setTimeout(
                $A.getCallback(function () {
                    $A.util.toggleClass(dropdownWrap, "header__wrap-dropdown-menu--active");
                }), 300
            );
        }
    }
})