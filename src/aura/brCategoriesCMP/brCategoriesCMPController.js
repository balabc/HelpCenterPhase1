({
	doInit: function(component, event, helper) {
        var selectedArticleId = component.get('v.selectedArticleId');

        component.set("v.items", []);
        component.set("v.data", {});


        var navDocScrollEv = function () {
            var cnNavFixed = 'doc-nav--fixed',
                nav = document.getElementsByClassName('doc-nav')[0],
                header = document.getElementsByClassName('header-pad')[0],
                breadcrumbs = document.getElementsByClassName('breadcrumbs')[0],
                footer = document.getElementsByClassName('footer')[0],
                headerHeight = header.offsetHeight,
                breadcrumbsHeight = breadcrumbs.offsetHeight,
                docNavDecorMarginBottom = 20,
                docNavInitPosTop = '70px';
            if (window.scrollY > breadcrumbsHeight) {
                nav.classList.add(cnNavFixed);

                if (( nav.offsetHeight + headerHeight ) > ( footer.getBoundingClientRect().top - docNavDecorMarginBottom - 374 )) {
                    nav.style.top = -( nav.offsetHeight - footer.getBoundingClientRect().top + docNavDecorMarginBottom + 374 ) + 'px';
                } else {
                    nav.style.top = docNavInitPosTop;
                }
            } else {
                nav.classList.remove(cnNavFixed);
            }
        };

        window.addEventListener('scroll', navDocScrollEv, false);
	},

    changeData: function(component, event, helper) {
        helper.changeData(component);
    },

    nullData: function(component, event, helper) {
        component.set("v.items", []);
    },

    clickCategory: function(component, event, helper) {
        var target = event.target,
            parent = target.parentElement,
            ul = parent.closest('ul'),
        	active = parent.getAttribute('data-active'),
            allChildOff = function(_parent) {
                var items = _parent.getElementsByClassName('doc-nav-category active');

                for (var i = 0; i < items.length; i++) {
                    items.item(i).setAttribute('data-active', false);
                    items.item(i).classList.remove('active');
                }
            };

        window.setTimeout(
            $A.getCallback(function() {
                if (active !== 'true') {
                    allChildOff(ul);

                    parent.setAttribute('data-active', true);
                    parent.classList.add('active');
                } else {
                    parent.setAttribute('data-active', false);
                    parent.classList.remove('active');
                }
            }), 100
        );
    },
    clickElement: function(component, event, helper) {

        var idRow = event.getParam("idRow");
        
        if (!$A.util.isUndefinedOrNull(idRow) && !$A.util.isEmpty(idRow)) {
            var parent = document.getElementById(idRow),
                active = parent.getAttribute('data-active'),
                items = document.getElementsByClassName("doc-nav__item-view active"),
                navEvt = $A.get("e.force:navigateToSObject"); //TODO change to navigateToSObject

            for (var i = 0; i < items.length; i++) {
                items.item(i).setAttribute('data-active', 'false');
                items.item(i).classList.remove('active');
            }

            if (active !== 'true') {
                parent.setAttribute('data-active', 'true');
                parent.classList.add('active');
            } else {
                parent.setAttribute('data-active', 'false');
                parent.classList.remove('active');
            }

            navEvt.setParams({
                "recordId": parent.getAttribute('data-id')
            });
            navEvt.fire();

            var toggleMenu = $A.get('e.c:brMobileNavMenuToggleEvent');
            toggleMenu.fire();
        }
    }
})