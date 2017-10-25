({
	doInit: function (cmp, event, helper) {
		helper.loadComments(cmp);
	},

	changeOrderToOldest: function (cmp, event, helper) {
		var items = cmp.get('v.commentsList');

		if (items.length === 0) {
			return;
		}

		cmp.set('v.orderDir', 'asc');
		helper.reloadComments(cmp);
	},

	changeOrderToNewest: function (cmp, event, helper) {
		var items = cmp.get('v.commentsList');

		if (items.length === 0) {
			return;
		}

		cmp.set('v.orderDir', 'desc');
		helper.reloadComments(cmp);
	},

	showMoreIdeaComments: function (cmp, event, helper) {
		helper.loadComments(cmp);
	},

	showCommentForm: function (cmp) {
        var authorizationMessage = $A.get('$Label.c.msgAuthorizationRequired'),
			usrInfo = cmp.get('v.commonVars.userInfo'),
            errEvt = cmp.getEvent('ideasErrorEvent');

		if (usrInfo.Type !== 'Guest') {
            cmp.set('v.showCommentForm', true);
        } else {
            errEvt.setParams({'type': 'auth_required', 'message': authorizationMessage});
            errEvt.fire();
        }
	},

	postComment: function (cmp, event, helper) {
		var commentText = cmp.find('commmentText').get('v.value');

		if (commentText === '') {
			return;
		}

		helper.postComment(cmp, commentText);
	},

	cancelPostComment: function (cmp) {
		cmp.set('v.showCommentForm', false);
	}
})