({
    initCommonVars: function(cmp){
    	var commonVars = cmp.get('v.commonVars');

    	if (!commonVars) {
            commonVars = {};
		}

    	commonVars.userInfo = {};
        commonVars.communityName = cmp.get('v.communityName');
        commonVars.enableProfileLink = cmp.get('v.configEnableProfileLink');

        cmp.set('v.commonVars', commonVars);
	},

	changeOrderBy: function(cmp, event, orderBy) {
		var orderLabel = event.getSource().get('v.label'),
			triggerEl = cmp.find('sortByListTrigger');

		if (triggerEl) {
			triggerEl.set('v.label', orderLabel);
		}

		cmp.set('v.orderBy', orderBy);
		cmp.set('v.orderByLabel', orderLabel);

		this.resetPaginationControlls(cmp);
		this.retrieveItems(cmp, (function(){
			this.retrievePagesTotal(cmp);
		}).bind(this));
	},

	retrieveUserInfo: function(cmp) {
		var action = cmp.get('c.getUserInfo'),
            commonVars = cmp.get('v.commonVars');

        action.setCallback(this, function(response) {
				var state = response.getState(),
					resVal = response.getReturnValue();

				if (state === 'SUCCESS') {
					cmp.set('v.userInfo', resVal);
                    commonVars.userInfo = resVal;
                    cmp.set('v.commonVars', commonVars);
                }
        	});

        $A.enqueueAction(action);
	},

	collectFilterData : function(cmp) {
        var filters = cmp.get('v.filters'),
            filterData = {};

    	for (var fname in filters) {
            if (fname === 'search') {
                filterData[fname] = filters[fname];
            } else {
                filterData[fname] = filters[fname].selected;
            }
        }

        filterData['search_by_title'] = cmp.get('v.configSearchByTitleOnly') ? 'true' : 'false';

        return filterData;
	},

    retrieveItems: function (cmp, callback) {
        var action = cmp.get('c.getIdeas');

        cmp.set('v.listLoading', true);
        cmp.set('v.listItems', []);

        action.setParams({
            community: cmp.get('v.communityName'),
            filterData: this.collectFilterData(cmp),
            page: cmp.get('v.currentPage'),
            itemsPerPage: cmp.get('v.itemsPerPage'),
            orderBy: cmp.get('v.orderBy')
        });

        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.listItems', resVal);

                if (typeof callback === 'function') {
                    callback();
                }
            }

            cmp.set('v.listLoading', false);
        });

        $A.enqueueAction(action);
    },

	retrieveItem: function(recordId, cmp, callback) {

	    cmp.set('v.listLoading', true);
    	var action = cmp.get('c.getIdea');

        action.setParams({
            recordId: recordId
        	});

        action.setCallback(this, function(response){
				var state = response.getState(),
					resVal = response.getReturnValue();

				if (state === 'SUCCESS') {
					cmp.set('v.listItems', [resVal]);

					if (typeof callback === 'function') {
						callback();
					}
				}

				cmp.set('v.listLoading', false);
        	});

        $A.enqueueAction(action);
	},

    retrievePagesTotal: function (cmp) {
        var action = cmp.get('c.getIdeasCount'),
            itemsPerPage = cmp.get('v.itemsPerPage');

        action.setParams({
            community: cmp.get('v.communityName'),
            filterData: this.collectFilterData(cmp)
        });

        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState(),
                itemsCount = 0,
                pagesTotal = 1;

            if (state === 'SUCCESS') {
                itemsCount = response.getReturnValue();

                if (itemsCount > 0) {
                    pagesTotal = Math.ceil(itemsCount / itemsPerPage);
                }

                cmp.set('v.pagesTotal', pagesTotal);
                cmp.set('v.itemsCount', itemsCount);
            }
        });

        $A.enqueueAction(action);
    },

	resetPaginationControlls: function(cmp) {
		cmp.set('v.currentPage', 1);
		cmp.set('v.pagesTotal', 1);
	},

	initFilterData: function(cmp) {
		var action = cmp.get('c.getFilterOptions');

		action.setParams({
            options: {
				categoriesSource: cmp.get('v.categoriesSource'),
				zone: cmp.get('v.communityName')
				}
        	});

        action.setCallback(this, function(response){
				var state = response.getState(),
					respVal = response.getReturnValue();

				if (state === 'SUCCESS' && typeof respVal === 'object') {
					for (var fname in respVal) {
						if (respVal.hasOwnProperty(fname)) {
							cmp.set('v.filters.' + fname + '.options', respVal[fname]);
						}
					}
				}
        	});

        $A.enqueueAction(action);
	},

	parseUrlHash: function() {
		var varsObj = {},
			hashArr = [],
			keyVal = [];

		if (location.hash !== null && location.hash.length > 0) {
            hashArr = location.hash.replace('#/', '').replace('#', '').split('&');

            for (var i = 0; i < hashArr.length; i+=1) {
                keyVal = hashArr[i].split("=");

                if (keyVal.length === 1) {
                	varsObj[keyVal[0]] = keyVal[0];
				}

				if (keyVal.length === 2) {
					varsObj[keyVal[0]] = keyVal[1];
				} else if (i === 0 && keyVal.length === 1 && keyVal[0].length >= 16) {
					varsObj.id = keyVal[0];
				}
            }
        }

		return varsObj;
	},

	updateOrderByLabel: function(cmp){
		var orderBy = cmp.get('v.orderBy');

		cmp.set('v.orderByLabel', $A.getReference('$Label.c.'+ orderBy +'Sorting'));
	},

	scrollToTop: function() {
		window.scrollTo(0, 0);
	}
})