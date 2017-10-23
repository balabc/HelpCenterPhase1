({
    loadCategoriesOptions : function(cmp){
        var action = cmp.get('c.getCategoriesOptions');

        action.setCallback(this, function(response) {
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.categoryOptions', resVal);
            }
        });

        $A.enqueueAction(action);
    },

    loadRecords : function(cmp){
        var action = cmp.get('c.getAssignments');

        action.setCallback(this, function(response) {
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === 'SUCCESS') {
                cmp.set('v.records', resVal);
            }
        });

        $A.enqueueAction(action);
    },

    saveRecord : function(cmp, username, categories){
        var action = cmp.get('c.saveAssignment');

        action.setParams({
            username: username,
            categories: categories
        });

        action.setCallback(this, function(response) {
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === 'SUCCESS') {
                if ($A.util.isEmpty(resVal.error) || resVal.error === '0'){
                    this.loadRecords(cmp);
                    cmp.set('v.createUsername', '');
                    cmp.set('v.createCategories', '');
                } else {
                    cmp.set('v.addErrorMsg', resVal.errorMsg);
                }
            }
        });

        $A.enqueueAction(action);
    },

    removeRecord : function(cmp, id){
        var action = cmp.get('c.deleteAssignment');

        action.setParams({
            aId: id
        });

        action.setCallback(this, function(response) {
            var state = response.getState(),
                resVal = response.getReturnValue();

            if (state === 'SUCCESS') {
                this.loadRecords(cmp);
            }
        });

        $A.enqueueAction(action);
    }

})