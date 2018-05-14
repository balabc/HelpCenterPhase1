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
                    var itemType = fmenuitems[index].Type;
                    var trg = baseURL + fmenuitems[index].Target;
                    item.label = fmenuitems[index].Label;
                    item.external = false;


                    if (itemType == 'SalesforceObject' && fmenuitems[index].Target == 'CollaborationGroup') {
                        trg = baseURL + '/group/' + fmenuitems[index].Target + '/' + fmenuitems[index].DefaultListViewId;
                    }

                    if (itemType == 'ExternalLink') {
                        trg = fmenuitems[index].Target;
                        item.external = true;
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

            action.setBackground();
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
            announcementBlockElement = document.getElementsByClassName('announcement-block')[0],
            arrow = document.getElementsByClassName('header__nav-arrow')[0];

        arrow.classList.toggle("nav-arrow--up");

        if (window.scrollY === 0) {
            if (arrow.className === 'header__nav-arrow nav-arrow nav-arrow--up') {
                $A.util.toggleClass(themeHeader, "header--make-sticky");
            } else {
                if (announcementBlockElement !== undefined) {
                    announcementBlockElement.style.position = 'relative';
                    announcementBlockElement.style.zIndex = '0';
                }
                window.setTimeout(
                    $A.getCallback(function () {
                        $A.util.toggleClass(themeHeader, "header--make-sticky");
                    }), 600);
            }
        }

        if (arrow.className === 'header__nav-arrow nav-arrow nav-arrow--up') {
            if (announcementBlockElement !== undefined) {
                document.getElementsByClassName('header--make-sticky')[0].style.top = announcementBlockElement.clientHeight + 'px';
                document.getElementsByClassName('header__wrap-dropdown-menu')[0].style.top = 70 + announcementBlockElement.clientHeight + 'px';
            }
            $A.util.toggleClass(dropdownWrap, "header__wrap-dropdown-menu--active");
            window.setTimeout(
                $A.getCallback(function () {
                    $A.util.toggleClass(dropdown, "header__dropdown-menu--active");
                }), 400);

        } else {
            $A.util.toggleClass(dropdown, "header__dropdown-menu--active");
            window.setTimeout(
                $A.getCallback(function () {
                    $A.util.toggleClass(dropdownWrap, "header__wrap-dropdown-menu--active");
                }), 300);
        }
    }
})