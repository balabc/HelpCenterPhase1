({
	doInit: function(cmp, event, helper) {
		var urlVars,
			isOpenedByDefault = !cmp.get('v.configFiltersCollapse');

		cmp.set('v.debugStartTime', Date.now());

        helper.initCommonVars(cmp);

		urlVars = helper.parseUrlHash();
		helper.retrieveUserInfo(cmp);

		if (urlVars.id) {
			helper.retrieveItem(urlVars.id, cmp, function(){
                    var item = cmp.find('listItem');

                    if (typeof item === 'object') {
                        item.set('v.showDetails', true);
                    }
                });
		} else {
			if (urlVars.idea_theme) {
				cmp.set('v.filters.idea_theme', urlVars.idea_theme);
			}

			/*helper.retrieveItems(cmp, function(){
					helper.retrievePagesTotal(cmp);
				});*/
		}

		var selectedIdeasFilter = '';

		if (urlVars['myideas'] !== undefined) {
            selectedIdeasFilter = 'createdByMe';
		}

		cmp.set('v.filters', {
			showBy: {opened: isOpenedByDefault, mOpened: false, options: '', selected: selectedIdeasFilter},
			category: {opened: isOpenedByDefault, mOpened: false, options: '', selected: ''},
			status: {opened: isOpenedByDefault, mOpened: false, options: '', selected: ''},
			search: ''
			});

		helper.initFilterData(cmp);
		helper.updateOrderByLabel(cmp);
        helper.retrieveItems(cmp, function(){
            helper.retrievePagesTotal(cmp);
        });
	},

	openCreateDialog: function(cmp) {
		var userInfo = cmp.get('v.userInfo');
		var authorizationMessage =  $A.get('$Label.c.msgAuthorizationRequired');
		var communityName = cmp.get('v.communityName');
		var categoryOptions = cmp.get('v.filters.category.options');
		var activeCategory = cmp.get('v.filters.category.selected');
		var ideaCreateForm = cmp.find('ideaCreateForm');

		if (userInfo && userInfo.Type !== '' && userInfo.Type !== 'Guest') {
            ideaCreateForm.open(communityName, categoryOptions, activeCategory);
		} else {
			var errEvt = cmp.getEvent('ideasErrorEvent');
			errEvt.setParams({'type':'auth_required', 'message': authorizationMessage});
			errEvt.fire();
		}
	},

	orderByTrending: function(cmp, event, helper){
		helper.changeOrderBy(cmp, event, 'Trending');
	},

	orderByPopular: function(cmp, event, helper){
		helper.changeOrderBy(cmp, event, 'Popular');
	},

	orderByRecent: function(cmp, event, helper){
		helper.changeOrderBy(cmp, event, 'Recent');
	},

	toggleFilter: function(cmp, event) {
		var targetEl = event.target,
			target = targetEl ? (targetEl.getAttribute('data-target') || '') : '',
			filters = cmp.get('v.filters');

		if (typeof filters !== 'object' || target === '' || !filters.hasOwnProperty(target)) {
			return;
		}

        cmp.set('v.filters.' + target + '.opened', !filters[target].opened);
	},

    toggleFilterMobile: function(cmp, event) {
        var targetEl = event.target,
            target = targetEl ? (targetEl.getAttribute('data-target') || '') : '',
            filters = cmp.get('v.filters');

        if (typeof filters !== 'object' || target === '') {
            return;
        }

        for (var fname in filters) {
            if (!filters.hasOwnProperty(fname)) {
                continue;
            }

            if (fname !== target || filters[fname].mOpened) {
                cmp.set('v.filters.' + fname + '.mOpened', false);
            } else {
                cmp.set('v.filters.' + fname + '.mOpened', true);
            }
        }
    },

	searchIdeas: function(cmp, event, helper) {
		var query = cmp.get('v.searchQuery');

		cmp.set('v.filters.search', query);

		helper.resetPaginationControlls(cmp);
		helper.retrieveItems(cmp, function(){
				helper.retrievePagesTotal(cmp);
			});
	},

	selectFilter: function(cmp, event, helper) {
		var targetEl = event.target,
			filterName = targetEl ? (targetEl.getAttribute('data-name') || '') : '',
			newVal = targetEl ? (targetEl.getAttribute('data-value') || '') : '',
			currentVal;

		if (filterName === '') {
			return;
		}

		currentVal = cmp.get('v.filters.' + filterName + '.selected');

		if (currentVal === newVal) {
			return;
		}

		cmp.set('v.filters.' + filterName + '.selected', newVal);

		helper.resetPaginationControlls(cmp);
		helper.retrieveItems(cmp, function(){
				helper.retrievePagesTotal(cmp);
			});

		cmp.set('v.filters.' + filterName + '.mOpened', false);
	},

	openPreviousPage: function(cmp, event, helper) {
		var p = cmp.get('v.currentPage');

		if (p > 1) {
			cmp.set('v.currentPage', p - 1);
			helper.retrieveItems(cmp);
			helper.scrollToTop();
		}
	},

	openNextPage: function(cmp, event, helper) {
		var p = cmp.get('v.currentPage'),
			pagesTotal = cmp.get('v.pagesTotal');

		if (p < pagesTotal) {
			cmp.set('v.currentPage', p + 1);
			helper.retrieveItems(cmp);
			helper.scrollToTop();
		}
	},

	handleOpenIdea: function(cmp, event) {
		var ideaId = event.getParam('id'),
			items = cmp.find('listItem');

		for (var i = 0; i < items.length; i+=1) {
			if (items[i].get('v.showDetails') && items[i].get('v.item.Id') !== ideaId) {
				items[i].set('v.showDetails', false);
			}
		}
	},

	handleIdeaCreated: function(cmp, event) {
		var newIdea = event.getParam('newIdea'),
			items = cmp.get('v.listItems');

		newIdea.Votes = [{Type:'Up'}];
		newIdea.isNew = true;
		items.unshift(newIdea);

		cmp.set('v.listItems', items);
	},

	handleErrorEvent: function(cmp, event) {
		var errorType = event.getParam('type'),
            message = event.getParam('message'),
            loginUrl = cmp.get('v.loginPage'),
			removeMsg = function() {
					if (cmp.isValid()) {
						cmp.set('v.systemMessage', {type: '', body: ''});
					}
				};

		if (errorType === 'auth_required' && (loginUrl && loginUrl !== '')) {
            var hdnLoginBtn = cmp.find('hiddenLoginBtn');

            hdnLoginBtn.getElement().click();

        } else {
            cmp.set('v.systemMessage', {type: 'error', body: message});

            setTimeout($A.getCallback(removeMsg), 5000);
		}
	}
})