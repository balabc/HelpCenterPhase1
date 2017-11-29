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
        console.log('cool');
        var Id = event.getParam("Id");
        console.log('Id: ' + Id);
        component.set('v.prevActiveMenuItemId', Id);
    }
})