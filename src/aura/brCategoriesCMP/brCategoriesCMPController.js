({
	doInit: function(component, event, helper) {
        //console.log('[DEBUG] [Controller] brCategoriesCMP:doInit');
        var selectedArticleId = component.get('v.selectedArticleId');

        component.set("v.items", []);
        component.set("v.data", {});

/*
        if(!!selectedArticleId) {
            helper.changeData(component);
        }
*/

        /*var data = component.get("v.data");
        if (!!data) {
            if (data.hasOwnProperty('id')) {
        		component.set('v.selectedArticleId', data.id);
            }
        	component.set("v.data", data);
        	helper.getResponse(component);
        }*/
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
                //console.log(items);
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


        //parent.setAttribute('data-active', ((active === 'true')? false: true));
    },
    clickElement: function(component, event, helper) {

        var idRow = event.getParam("idRow");
        
        if (!!idRow) {
            var parent = document.getElementById(idRow),
                active = parent.getAttribute('data-active'),
                items = document.getElementsByClassName("doc-nav__item-view active"),
                //navEvt = $A.get("e.force:navigateToURL"); //TODO change to navigateToSObject
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

/*            navEvt.setParams({
                "url": '/article/' + parent.getAttribute('data-id')
            });*/
            navEvt.setParams({
                "recordId": parent.getAttribute('data-id')
            });
            navEvt.fire();

            var toggleMenu = $A.get('e.c:brMobileNavMenuToggleEvent');
            toggleMenu.fire();
        }
    }
})