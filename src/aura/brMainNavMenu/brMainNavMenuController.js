({
    doInit: function (cmp, event, helper) {
        helper.fetchMenuItems(cmp);

        window.onscroll = function () {
            var cnHeader = 'header',
                cnHeaderSticky = 'header--make-sticky',
                cnSubstrate = 'header__dropdown-menu-substrate',
                cnSubstrateActive = 'header__dropdown-menu-substrate--active',
                dropdown = cmp.find('dropdown'),
                isOpenSubmenu = false;

            if (dropdown.getElement() !== null) {
                isOpenSubmenu = dropdown.getElement().classList.contains('header__dropdown-menu--active');
            }

            var header = document.getElementsByClassName(cnHeader)[0],
                substrate = document.getElementsByClassName(cnSubstrate)[0];

            if ((window.scrollY > 0 || isOpenSubmenu)
                && header !== undefined) {
                header.classList.add(cnHeaderSticky);
            } else {
                if (substrate !== undefined && header !== undefined) {
                    if (!substrate.classList.contains(cnSubstrateActive)){
                        header.classList.remove(cnHeaderSticky);
                    }
                }
            }
        };
        helper.getNavigationMenuItemExternalLabels(cmp);
    },
    addLabels : function(component, event, helper) {
        var itemLabels = component.get('v.itemLabels'),
            oldMenuItems = component.get('v.menu');

        for (var i in itemLabels) {
            helper.addLabels(component, itemLabels[i], oldMenuItems);
        }
    },
    onCategoryClick : function(component, event, helper) {
        try {
            //var sss = component.get('v.menuItems');
            //console.log('menuItems',sss);
            //var exitingURL = event.target.dataset.url;
            //if(exitingURL){
            //   //console.log('Menu Category - using exiting URL' + exitingURL);
            //    var urlEvent = $A.get("e.force:navigateToURL");
            //    urlEvent.setParams({
            //      "url": exitingURL
            //    });
            //    urlEvent.fire();
            //}else{
            helper.toggleSubMenu(component);
                var action = component.get("c.getURLByMenuLabel");
                var itemLabel = event.target.dataset.label;
                if (itemLabel) {
                    action.setParams({
                        fullurl : window.location.href,
                        label : itemLabel
                    });
                    action.setStorable();

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
                        } else if (state === "ERROR") {
                            var errors = response.getError();
                            var error_msg = '';
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    if (errors[0].message === 'access_error') {
                                        error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                                    } else {
                                        error_msg = errors[0].message;
                                    }
                                }
                            }
                            if (error_msg.length === 0) {
                                error_msg = $A.get("$Label.c.hUnknownError");
                            }
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                mode: "sticky",
                                message: error_msg
                            });
                            toastEvent.fire();
                        }
                    });
                    $A.enqueueAction(action);
                }
            //}
        }catch(e){
           //console.log('tryE:', e);
        }
    },
    onClick : function(cmp, event) {
        var id = event.target.dataset.menuItemId;

        if (id) {
            cmp.getSuper().navigate(id);
            if (window.location.href.indexOf('/login') !== -1) {
                var url = window.location.href;
                url = url.replace('/login', '');
                window.location.href = url;
            }
        }
    },
    toggleSubMenu: function (cmp, event, helper) {
        helper.toggleSubMenu(cmp);
    },
    closeSubMenu: function (component, event, helper) {
        var themeHeader = document.getElementById("themeHeader"),
            dropdownWrap = component.find('dropdownWrap'),
            dropdown = component.find('dropdown'),
            arrow = component.find('arrow');

        $A.util.removeClass(arrow, "nav-arrow--up");

        if (window.scrollY === 0) {
            if (arrow.getElement().className === 'header__nav-arrow nav-arrow') {
                $A.util.removeClass(themeHeader, "header--make-sticky");
            } else {
                setTimeout( function () {
                    $A.util.removeClass(themeHeader, "header--make-sticky");
                }, 600);
            }
        }

        if (arrow.getElement().className === 'header__nav-arrow nav-arrow') {
            $A.util.removeClass(dropdownWrap, "header__wrap-dropdown-menu--active");
            window.setTimeout(
                $A.getCallback(function () {
                    $A.util.removeClass(dropdown, "header__dropdown-menu--active");
                }), 400
            );
        } else {
            $A.util.removeClass(dropdown, "header__dropdown-menu--active");
            window.setTimeout(
                $A.getCallback(function () {
                    $A.util.removeClass(dropdownWrap, "header__wrap-dropdown-menu--active");
                }), 300
            );
        }
    }
})