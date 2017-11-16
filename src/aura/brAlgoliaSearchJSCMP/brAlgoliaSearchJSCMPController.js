({
    doInit: function(component, event, helper) {
    },
    clearSearch: function(component, event, helper) { 
        component.set("v.searchText", '');
        component.set("v.categories", null);
        component.set("v.hasData", 'off');
    },
    searchChange: function(component, event, helper) {
        var query = component.get("v.searchText"),
            changeSearch = $A.get("e.c:brChangeHeaderSearchBarEvent");
        
        if (query.length >= 3) { 
            helper.getSearchResult(component);
        } else {
            component.set("v.categories", null);
            component.set("v.hasData", 'off');
        }
        console.log(query);
        changeSearch.setParams({"search": query});
        changeSearch.fire();
    },
    filterChange: function(component, event, helper) { 
        var query = component.get("v.searchText");
        if(!!query && (query.length > 0)) {
            if(query.length >= 3) {
        		helper.getSearchResult(component);
            }
        }
    },
    onChangeFilter: function(component, event, helper) {
		var filter = event.getParam("brFilter");
        component.set("v.brFilter", filter);
	},
    filterChangeState: function(component, event, helper) {
        console.log('asdfsadfsadsfda');
		var hasData = component.get("v.hasData"),
            icon = document.getElementById('serp__filter-trigger'),
            class_disabled = 'icon_disabled';
        if (hasData == 'off') {
            if (!icon.classList.contains(class_disabled)) {
            	icon.classList.add(class_disabled);
            }
        } else {
            icon.classList.remove(class_disabled);
        }
	},
    searchFill: function(component, event, helper) { 
        var listData = component.get("v.listData"),
            id = event.target.getAttribute('data-id');
        component.set("v.searchText", listData[id].data.name); 
        component.set("v.hasData", 'off'); 
    },
    jsLoaded: function(component, event, helper) { 
    	component.set("v.hasData", 'off');
    	document.getElementById('serp__filter-trigger').addEventListener('click', function() {  
            var has_filter = document.getElementsByClassName('serp__filter-section')[0].getAttribute('data-active');
            if (has_filter == 'true') {
                var body_classes = document.body.classList,
                    class_is_mobile = 'is-mobile',
                    class_mobile = 'mobile-search-filter-is-active',
                    body_classes_mobile = body_classes.contains(class_mobile);
                if (body_classes_mobile) {
                    body_classes.remove(class_is_mobile);
                    body_classes.remove(class_mobile);
                } else {
                    body_classes.add(class_is_mobile);
                    body_classes.add(class_mobile);
                }
                document.body.classList = body_classes;
            }
        }, false);
    }/*,
    toggleMobileFilter: function(component, event, helper) { 
        var body_classes = document.body.classList,
            class_mobile = 'mobile-search-filter-is-activ',
            body_classes_mobile = body_classes.indexOf(class_mobile);
        console.log(body_classes, body_classes_mobile);
        if (body_classes_mobile > -1) {
            body_classes.splice(body_classes_mobile, 1);
        } else {
            body_classes.push(class_mobile);
        }
        document.body.classList = body_classes;
    }*/
})