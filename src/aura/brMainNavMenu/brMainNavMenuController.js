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
    onCategoryClick : function(component, event) {
        try {
            //var sss = component.get('v.menuItems');
            //console.log('menuItems',sss);
            //var exitingURL = event.target.dataset.url;
            //if(exitingURL){
            //    console.log('Menu Category - using exiting URL' + exitingURL);
            //    var urlEvent = $A.get("e.force:navigateToURL");
            //    urlEvent.setParams({
            //      "url": exitingURL
            //    });
            //    urlEvent.fire();
            //}else{
                var action = component.get("c.getURLByMenuLabel");
                var itemLabel = event.target.dataset.label;
                if (itemLabel) {
                    action.setParams({
                        fullurl : window.location.href,
                        label : itemLabel
                    });
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var target = response.getReturnValue();
                            if(target){
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                  "url": target
                                });
                                urlEvent.fire();
                            }
                        }else if (state === "ERROR") {
                            var errors = response.getError();
                            console.log("Errors: ", errors);
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " + errors[0].message);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
                    });
                    $A.enqueueAction(action);
                }
            //}
        }catch(e){
            console.log('tryE:', e);
        }
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