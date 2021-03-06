({
    doInit: function(component, event, helper) {
        helper.getApiKey(component);
    },
    clearSearch: function(component, event, helper) {
        component.set("v.searchText", '');
        component.set("v.categories", null);
        component.set("v.hasData", 'off');
    },
    searchChange: function(component, event, helper) {
        var query = component.get("v.searchText"),
            changeSearch = $A.get("e.c:brChangeHeaderSearchBarEvent");

        document.cookie = "searchTerm=" + escape(query) + "" + "; path=/";//BIG-71 fix

        if (query.length >= 1) {
            helper.getSearchResult(component);
        } else {
            component.set("v.categories", null);
            component.set("v.hasData", 'off');
        }
        changeSearch.setParams({"search": query});
        changeSearch.fire();
    },
    onClickViewMore: function(component, event, helper) {
        component.set('v.countClickViewMore', component.get('v.countClickViewMore') + 1);
        var target = event.target,
            objSfdcSite = $A.get('$SfdcSite'),
            url = target.dataset.link,
            filter = component.find('algolia_search_filter'),
            elem;
        
        objSfdcSite = (!$A.util.isUndefinedOrNull(objSfdcSite)? objSfdcSite.pathPrefix: '');
        
        switch (url) {
            case (objSfdcSite + '/s/knowledge'): {
                elem = filter.find('filter_row_kb').getElement();
                break;
            }  
            case (objSfdcSite + '/s/community'): {
                elem = filter.find('filter_row_cm').getElement();
                break;
            }  
            case (objSfdcSite + '/s/ideas'): {
                elem = filter.find('filter_row_ideas').getElement();
                break;
            }
        }
        
        if (!$A.util.isUndefinedOrNull(elem) && !$A.util.isEmpty(elem)) {
            elem.getElementsByClassName('filter__section-title')[0].click();
        }
    },
    filterChange: function(component, event, helper) {
        if (component.get('v.countClickViewMore') === 1) {
            var query = component.get("v.searchText");
            if(!!query && (query.length > 0)) {
                if(query.length >= 1) {
                    helper.getSearchResult(component);
                }
            }
        } else {
            component.set('v.countClickViewMore', 1);
        }
    },
    onChangeCountViewMore: function(component, event, helper) {
        var query = component.get("v.searchText");
        if(!!query && (query.length > 0)) {
            if(query.length >= 1) {
                helper.getSearchResult(component);
            }
        }
    },
    onChangeFilter: function(component, event, helper) {
		var filter = event.getParam("brFilter");
        component.set("v.brFilter", filter);
	},
    filterChangeState: function(component, event, helper) {
		var hasData = component.get("v.hasData"),
            icon = document.getElementById('serp__filter-trigger'),
            class_disabled = 'icon_disabled';
        if (hasData === 'off') {
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
    },
    toggleMobileFilter: function(component, event, helper) {
        helper.toggleMobileFilter(component);
    },
    filterClose: function(component, event, helper) {
        helper.toggleMobileFilter(component);
        //set class "filter_ask_to_skip" that will be used by other function to ignore on click action
        var closediv = component.find("close_filter").getElement();
        if (!!closediv && (typeof closediv.classList !== "undefined")) {
            if (! closediv.classList.contains("filter_ask_to_skip") ) {
                closediv.classList.add("filter_ask_to_skip");
            }
        }
    }
})