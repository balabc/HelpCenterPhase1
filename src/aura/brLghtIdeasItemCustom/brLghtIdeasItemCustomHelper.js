({
	cutText: function (text, maxLengthParam) {
		var resultText,
			lastWordPos,
			maxLength = parseInt(maxLengthParam, 10);

		if (typeof text !== 'string' || maxLength < 1) {
			return '';
		}

		if (text.length <= maxLength) {
			return text;
		}

		resultText = text.substr(0, maxLength);
		lastWordPos = resultText.lastIndexOf(' ');

		if (lastWordPos > 0) {
			resultText = resultText.substr(0, lastWordPos);
		}

		return resultText;
	},

	addVote: function (cmp, voteType, callback) {
		var action = cmp.get('c.addVote');

		action.setParams({
            ideaId: cmp.get('v.item.Id'),
			voteType: voteType
        	});

        action.setCallback(this, function(response){
				var state = response.getState(),
					respVal = response.getReturnValue();

				if (state === "SUCCESS") {
					if (typeof callback === 'function') {
						callback(respVal);
					}
				} else {
					//TODO: handle error
				}
        	});

        $A.enqueueAction(action);
	},

	getStatus: function (cmp, callback) {
		var action = cmp.get('c.getStatus');

		action.setParams({
            ideaId: cmp.get('v.item.Id')
        	});

        action.setCallback(this, function(response){
				var state = response.getState(),
					respVal = response.getReturnValue();

				if (state === 'SUCCESS' && typeof callback === 'function') {
					callback(respVal);
				}
        	});

        $A.enqueueAction(action);
	},

	loadMerged: function(cmp) {
		var action = cmp.get('c.getMergedIdeas');

		action.setParams({
            parentId: cmp.get('v.item.Id')
        	});

        action.setCallback(this, function(response){
				var state = response.getState(),
					respVal = response.getReturnValue();

				if (state === "SUCCESS") {
					cmp.set('v.mergedIdeas', respVal);
				}
        	});

        $A.enqueueAction(action);
	},

    updateCommentsNumber: function(cmp) {
        var action = cmp.get('c.getIdeaCommentsNumber');

        action.setParams({
            ideaId: cmp.get('v.item.Id')
        });

        action.setCallback(this, function(response){
            var state = response.getState(),
                respVal = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.item.NumComments', respVal);
            }
        });

        $A.enqueueAction(action);
    }
})