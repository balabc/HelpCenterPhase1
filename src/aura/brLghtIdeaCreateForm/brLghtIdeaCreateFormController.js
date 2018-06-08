({
	init: function(cmp){
        cmp.set('v.isVisible', false);
        cmp.set('v.fieldsError', {});
    },

	handleVisibilityChange: function(cmp){
		cmp.set('v.category', cmp.get('v.activeCategory'));
		cmp.set('v.errorMsg', '');
	},

	cancel: function(cmp){
		cmp.set('v.isVisible', false);
	},

	save: function(cmp){
		var action = cmp.get('c.createNewIdea'),
			title = cmp.get('v.title'),
			category = cmp.get('v.category'),
			body = cmp.get('v.bodyText'),
			categoryRequired = cmp.get('v.categoryRequired'),
            fieldsError = {},
			error = '';

		if (title.length < 5) {
            fieldsError.titleEmpty = true;
		}

		if (body.length < 5) {
            fieldsError.bodyEmpty = true;
		}

		if (categoryRequired && $A.util.isEmpty(category)) {
            fieldsError.categoryEmpty = true;
		}

		if (fieldsError.titleEmpty || fieldsError.bodyEmpty || fieldsError.categoryEmpty) {
            error = $A.get('$Label.c.fillRequiredFieldsMsg');
        }

		cmp.set('v.errorMsg', error);
        cmp.set('v.fieldsError', fieldsError);

		if (error !== '') {
			return;
		}

		var fields = {
				community: cmp.get('v.communityName'),
				title:     title,
				body:      body,
				category:  category
			};

        action.setParams({
            fields: fields
        	});

        action.setCallback(this, function(response){
				var state = response.getState(),
					returnVal = response.getReturnValue(),
					successEvent = cmp.getEvent('ideaCreateSuccess');

				cmp.set('v.isSaving', false);

				if (state === 'SUCCESS' && returnVal !== null) {
					cmp.set('v.isVisible', false);

					successEvent.setParams({'newIdea': returnVal});
					successEvent.fire();
				} else {
					var errors = response.getError(),
						msg = 'Unknown error';

					if (errors && errors[0] && errors[0].message) {
						msg = errors[0].message;
					}

					cmp.set('v.errorMsg', msg);
				}

				cmp.set('v.title', '');
				cmp.set('v.category', '');
				cmp.set('v.bodyText', '');
				cmp.set('v.similarIdeas', []);
        	});

        $A.enqueueAction(action);

		cmp.set('v.isSaving', true);
	},

	searchSimilar: function(cmp) {
		var action = cmp.get('c.getSimilarIdeas'),
			title = cmp.get('v.title');

		action.setParams({
            community: cmp.get('v.communityName'),
			title: title
        	});

        action.setCallback(this, function(response){
			var state = response.getState(),
				returnVal = response.getReturnValue();

			if (state === 'SUCCESS') {
				cmp.set('v.similarIdeas', returnVal);
			}
        });

        $A.enqueueAction(action);
	},

	open: function (cmp, event) {
        var params = event.getParam('arguments'),
            communityName = params.communityName,
            categoryOptions = params.categoryOptions,
            activeCategory = params.activeCategory;

        cmp.set('v.communityName', communityName);
        cmp.set('v.categoryOptions', categoryOptions);
        cmp.set('v.activeCategory', activeCategory);

        cmp.set('v.title', '');
        cmp.set('v.bodyText', '');
        cmp.set('v.similarIdeas', []);
        cmp.set('v.fieldsError', {});

        cmp.set('v.isVisible', true);
    }
})