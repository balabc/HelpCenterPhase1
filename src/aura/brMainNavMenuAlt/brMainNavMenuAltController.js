({
    doInit: function (component, event) {
        window.onscroll = function () {
            var cnHeader = 'header',
                cnHeaderSticky = 'header--make-sticky',
                cnSubstrate = 'header__dropdown-menu-substrate',
                cnSubstrateActive = 'header__dropdown-menu-substrate--active',
                prevActiveMenuItem = component.get('v.prevActiveMenuItemId');

            if ( window.scrollY > 0 || (prevActiveMenuItem != '' && prevActiveMenuItem != undefined && window.scrollY == 0)) {
                document.getElementsByClassName( cnHeader )[0].classList.add( cnHeaderSticky );
            } else {
                if ( !document.getElementsByClassName( cnSubstrate )[0].classList.contains( cnSubstrateActive ) ) {
                    document.getElementsByClassName( cnHeader )[0].classList.remove( cnHeaderSticky );
                }
            }
        };
    },
    onClick : function(component, event) {
        var id = event.target.dataset.menuItemId;
        if (id) {
            component.getSuper().navigate(id);
        }
    },
    setMenuItemId: function (component, event) {
        var Id = event.getParam("Id");
        component.set('v.prevActiveMenuItemId', Id);
    },
    closeSubMenu: function (component, event) {
        var dropdown = document.getElementsByClassName("header__wrap-dropdown-menu--active"),
            themeHeader = document.getElementById("themeHeader");
        $A.util.removeClass(dropdown[0], "header__wrap-dropdown-menu--active");
        setTimeout( function () {
            $A.util.removeClass(themeHeader, "header--make-sticky");
        }, 750);
    }
})