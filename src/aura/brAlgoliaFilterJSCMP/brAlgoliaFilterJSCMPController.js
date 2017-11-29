({
    doInit: function(component, event, helper) {
        var objFilter = {
            kb: {
                article_type: {
                    user_docs: false,
                    videos: false,
                    guides: false
                }
            }, 
            cm: {
                posted_in: 'All',
                is_answer: false,
                record_type: {
                    comment: true,
                    question: true,
                    post: true,
                    announcement: true
                },
                sorting_index: 'FeedItem_Community'
            },
            ideas: {
                record_type: 'All',
                is_merged: false,
                status: {
                    under_point_threshold: false,
                    closed: false,
                    delivered: false,
                    in_planning: false,
                    is_new: false,
                    existing_feature: false,
                    future: false,
                    app_available: false,
                    in_development: false,
                    not_planned: false,
                    in_beta: false,
                    partner_solution: false,
                    under_consideration: false
                },
                sorting_index: 'Ideas_Community'
            }
            
        };
        
        component.set("v.brFilter", objFilter);
    },
    onRadio: function(component, event) {
        /*var objFilter = component.get('v.brFilter');
        console.log(objFilter, event);
        objFilter.cm.posted_in = event.getSource().get("v.label");
        component.set("v.brFilter", objFilter);*/
    }, 
    onSelect: function(component, event) {
        /*var objFilter = component.get('v.brFilter'); 
        console.log(objFilter, event); 
        objFilter.cm.sorting_index = event.getSource().get("v.value");
        component.set("v.brFilter", objFilter);*/
    },
	onClickFilterRow : function(component, event, helper) {
        var has_filter = document.getElementsByClassName('serp__filter-section')[0].getAttribute('data-active'),
            parent = event.target.closest('.filter__section-head').parentElement,
        	active = parent.getAttribute('data-active'),
        	currentFilter = parent.getAttribute('data-type'),
            allChildOff = function(_parent) {
                var items = _parent.getElementsByClassName('filter__section');
                for (var i = 0; i < items.length; i++) {
                    items.item(i).setAttribute('data-active', false)
                }
            };
        	allChildOff(parent.parentElement);
        component.set("v.currentFilter", currentFilter);
        parent.setAttribute('data-active', ((active == 'true')? false: true));
        
        if (has_filter == 'true') {
            var body_classes = document.body.classList,
                class_is_mobile = 'is-mobile', 
                class_mobile = 'mobile-search-filter-is-active';
            
            if (body_classes.contains(class_is_mobile)) {
                if (body_classes.contains(class_mobile)) {
                    body_classes.remove(class_mobile);
                } else {
                    body_classes.add(class_mobile);
                }
            }
        }
	},
    onChangeFilter: function(component, event, helper) {
        helper.toChangeFilter(component);
    },
    onChangeAvailableIndexes: function(component, event, helper) {
        var availableIndexes = component.get('v.availableIndexes'),
            boolsAvailableIndexes = {};
        if (availableIndexes.length > 0) {
            for (var i in availableIndexes) {
                if (availableIndexes.hasOwnProperty(i)) {
                    boolsAvailableIndexes[availableIndexes[i]] = true;
                }
            }
        }
        component.set('v.boolsAvailableIndexes', boolsAvailableIndexes);
    }
})