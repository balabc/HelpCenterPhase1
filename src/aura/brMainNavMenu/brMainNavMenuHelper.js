({
    toggleSubMenu: function (cmp) {
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
    },
    getNavigationMenuItemExternalLabels: function (cmp) {
        var action = cmp.get("c.getLabels");
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var labels = response.getReturnValue();
                    cmp.set('v.labels', labels);
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
})