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
		var parent = event.target.parentElement.parentElement,
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
	},
    onChangeFilter: function(component, event, helper) {
        helper.toChangeFilter(component);
    }
})