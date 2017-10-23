({
    setFilters: function(component) {
        component.set('v.filters', {});
        component.set('v.currentFilter', '');

        var urlVars,
            filters = component.get('v.filters');
        urlVars = this.parseUrlHash();

        if(urlVars.hasOwnProperty('tag') && urlVars.tag.length > 0){
            filters['tag'] = urlVars.tag;
            component.set('v.filters', filters);
            component.set('v.currentPage', 1);
        }
        else if(urlVars.hasOwnProperty('category') && urlVars.category.length > 0){
            filters['category'] = urlVars.category;
            component.set('v.filters', filters);
            component.set('v.currentPage', 1);
        }
    },

    retrieveArticles: function(component) {
        var action = component.get("c.getArticles"),
            spinner = component.find("spinner"),
            filters = component.get('v.filters');

        component.set("v.articles", []);
        $A.util.toggleClass(spinner, "slds-hide");

        action.setParams({
           "filterData": this.getFilterParams(filters),
            "page": component.get('v.currentPage'),
            "itemsPerPage": component.get('v.itemsPerPage')
        });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === 'SUCCESS') {
                var articles = response.getReturnValue();
                component.set("v.articles", articles);

                if (articles.length !== 0) {
                    if (filters.hasOwnProperty('category')) {
                        this.setCurrentFilterCategories(component, filters['category'], articles[0].categories);
                    } else if (filters.hasOwnProperty('tag')) {
                        this.setCurrentFilterTags(component, filters['tag'], articles[0].tags);
                    }
                }
            }

            $A.util.toggleClass(spinner, "slds-hide");
            var componentButtons = component.find("componentButtons");
            $A.util.removeClass(componentButtons, "slds-hide");
        });
        $A.enqueueAction(action);
    },

    setCurrentFilterCategories: function(component, filter, categories) {
        
        for (var i = 0; i < categories.length; i++) {
            if (categories[i].Friendly_URL__c === filter) {
                var currentFilter = component.find('currentFilter');
                $A.util.removeClass(currentFilter, 'slds-hide');
                component.set("v.currentFilter", $A.get("$Label.c.CategoriesFilteredName") + ' ' + categories[i].Name);
                break;
            }
        }     
    },

    setCurrentFilterTags: function(component, filter, tags) {

        for (var i = 0; i < tags.length; i++) {
            if (tags[i].Friendly_URL__c === filter) {
                var currentFilter = component.find('currentFilter');
                $A.util.removeClass(currentFilter, 'slds-hide');
                component.set("v.currentFilter", $A.get("$Label.c.TagsFilteredName") + ' ' + tags[i].Name);
                break;
            }
        }     
    },


    retrieveArticlesCount: function(component) {
        var action = component.get("c.getArticlesCount");

        action.setParams({
           "filterData": this.getFilterParams(component.get('v.filters'))
        });

        action.setCallback(this, function(response) {
            var state = response.getState(),
                itemsPerPage = component.get('v.itemsPerPage'),
                itemsCount = 0,
                pagesTotal = 1;

            if (state === 'SUCCESS') {
                itemsCount = response.getReturnValue();

                if (itemsCount > 0) {
                    pagesTotal = Math.ceil(itemsCount/itemsPerPage);
                }

                component.set('v.pagesTotal', pagesTotal);
            }

        });
        $A.enqueueAction(action);
    },

    changePage: function(component, direction) {
        var currentPage = component.get('v.currentPage'),
            pagesTotal = component.get('v.pagesTotal');

        component.set('v.currentFilter', '');
        var componentButtons = component.find("componentButtons");
        $A.util.addClass(componentButtons, "slds-hide");

        if(direction === 'next') {
            if (currentPage < pagesTotal) {
                component.set('v.currentPage', currentPage + 1);
                this.retrieveArticles(component);
                this.scrollToTop();
            }
        } else if(direction === 'prev') {
            if (currentPage > 1) {
                component.set('v.currentPage', currentPage - 1);
                this.retrieveArticles(component);
                this.scrollToTop();
            }
        } else{
            //TODO handle unexpected param
        }
    },

    getFilterParams: function(filters) {
        var filterParams = {};

        for (var key in filters) {
            if (filters.hasOwnProperty(key)) {
                filterParams[key] = filters[key];
            }
        }

        return filterParams;
    },

    parseUrlHash: function() {
        var varsObj = {},
            hashArr = [],
            keyVal = [];

        if (typeof location.hash !== 'undefined' && location.hash && location.hash.length > 0) {
            hashArr = location.hash.replace('#/', '').replace('#', '').split('&');

            for (var i = 0; i < hashArr.length; i+=1) {
                keyVal = hashArr[i].split("=");

                if (keyVal.length === 2) {
                    varsObj[keyVal[0]] = keyVal[1];
                } else if (i === 0 && keyVal.length === 1) {
                    varsObj.id = keyVal[0];
                }
            }
        }
        return varsObj;
    },

    scrollToTop: function() {
        window.scrollTo(0, 0);
    }
})