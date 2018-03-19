({
    fetchMenuItems : function(component) {
        var action = component.get("c.getMenuItems");
        var menuitems = [];

        action.setCallback(this, function(response) {
            var itemLabels = [];
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                var fmenuitems = result;
                var baseURL = $A.get("$Site").siteUrlPrefix;
                menuitems.push({label: 'Home', target: baseURL});

                for (var index in fmenuitems) {
                    var item = {};
                    item.label = fmenuitems[index].Label;
                    var itemType = fmenuitems[index].Type;
                    var trg = baseURL + fmenuitems[index].Target;


                    if (itemType == 'SalesforceObject' && fmenuitems[index].Target == 'CollaborationGroup') {
                        trg = baseURL + '/group/' + fmenuitems[index].Target + '/' + fmenuitems[index].DefaultListViewId;
                    }

                    if (itemType == 'ExternalLink') {
                        trg = fmenuitems[index].Target;
                    }

                    if (itemType == 'MenuLabel') {
                           itemLabels.push(item.label);
                    } else {
                        item.target = trg;
                        menuitems.push(item);
                    }
                }

                component.set('v.itemLabels', itemLabels);
                component.set('v.menu', menuitems);
                component.set('v.endDoInit', true);
            }
        });

        $A.enqueueAction(action);
    },
    addLabels : function(component, label, oldMenuItems) {
        var action = component.get("c.getURLByMenuLabel");

        if (label) {
            action.setParams({
                fullurl: window.location.href,
                label: label
            });

            action.setStorable();
            action.setCallback(this, function (response) {
                var state = response.getState();

                if (state === "SUCCESS") {
                    var item = {};
                    item.target = response.getReturnValue();
                    item.label = label;
                    oldMenuItems.push(item);
                }
                component.set('v.menu', oldMenuItems);
            });

            $A.enqueueAction(action);
        }
    },
    toggleSubMenu: function (cmp, event) {
        var themeHeader = document.getElementById("themeHeader"),
            dropdownWrap = cmp.find('dropdownWrap'),
            dropdown = cmp.find('dropdown'),
            arrow = cmp.find('arrow');

        $A.util.toggleClass(arrow, "nav-arrow--up");

        if (window.scrollY === 0) {
            if (arrow.getElement().className === 'header__nav-arrow nav-arrow') {
                $A.util.toggleClass(themeHeader, "header--make-sticky");
            } else {
                setTimeout( function () {
                    $A.util.toggleClass(themeHeader, "header--make-sticky");
                }, 600);
            }
        }

        if (arrow.getElement().className === 'header__nav-arrow nav-arrow') {
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
        action.setStorable();

            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var labels = response.getReturnValue();
                    //console.log(labels);
                    cmp.set('v.labels', labels);
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
    },
    getMenuLabelUrl: function (component, itemLabel) {

    }
})