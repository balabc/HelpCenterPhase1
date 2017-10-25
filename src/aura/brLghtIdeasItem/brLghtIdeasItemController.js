({
	doInit: function (cmp, event, helper) {
		var idea = cmp.get('v.item');

		cmp.set('v.shortBody', helper.cutText(idea.Body, 300));

		if (typeof idea.Categories === 'string' && idea.Categories !== '') {
			cmp.set('v.Categories', idea.Categories.replace(new RegExp(';', 'g'), ' | '));
		}

		if (typeof idea.Votes === 'object') {
			cmp.set('v.voteStatus', idea.Votes[0].Type);
		} else {
    		cmp.set('v.voteStatus', 'undefined');
    	}

		if (idea.isNew) {
			cmp.set('v.isCreated', true);
		}
	},

	toggleIdea: function (cmp, event, helper) {
		if (!cmp.get('v.showDetails')) {
			cmp.set('v.showDetails', true);

			helper.loadMerged(cmp);

			var openIdeaEvent = cmp.getEvent('openIdeaEvent');
			openIdeaEvent.setParams({'id': cmp.get('v.item.Id')});
			openIdeaEvent.fire();
		} else {
			cmp.set('v.showDetails', false);
		}
	},

	pushVote: function (cmp, event, helper) {
		var voteType = event.target.getAttribute('data-value'),
		    authorizationMessage = $A.get('$Label.c.msgAuthorizationRequired');

		helper.addVote(cmp, voteType, function(newVoteTotal) {
				if (newVoteTotal !== 'error' && newVoteTotal !== 'auth_required') {
					cmp.set('v.voteTotal', newVoteTotal);
					cmp.set('v.voteStatus', voteType);

                    helper.getStatus(cmp, function(newStatus) {
                        	cmp.set('v.item.Status', newStatus);
                        });

				} else if (newVoteTotal === 'auth_required') {
					var errEvt = cmp.getEvent('ideasErrorEvent');
					errEvt.setParams({'type':'auth_required', 'message':authorizationMessage});
					errEvt.fire();
				} else {
					//TODO: handle error
				}
			});
	},

	openTab: function (cmp, evt) {
		cmp.set('v.activeTab', evt.target.getAttribute('id'));
	},

    updateCommentsNumberHandler: function (cmp, evt, helper) {
        helper.updateCommentsNumber(cmp);
    }
})