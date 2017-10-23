({
    init : function(cmp, evt, helper){
        cmp.set('v.records', []);
        cmp.set('v.categoryOptions', []);
        helper.loadCategoriesOptions(cmp);
        helper.loadRecords(cmp);
    },

    edit : function(cmp, evt, helper){
        var btn = evt.getSource(),
            records = cmp.get('v.records');

        for (var rec_i = 0; rec_i < records.length; rec_i += 1) {
            if (records[rec_i].Id === btn.get('v.value')) {
                cmp.set('v.createUsername', records[rec_i].User__r.Username);
                cmp.set('v.createCategories', records[rec_i].Categories__c);
            }
        }
    },

    save : function(cmp, evt, helper){
        var username = cmp.get('v.createUsername'),
            categories = cmp.get('v.createCategories');

        cmp.set('v.addErrorMsg', '');

        if (username === '' || username.indexOf('@') < 1) {
            cmp.set('v.addErrorMsg', 'Invalid username format');
            return;
        }

        helper.saveRecord(cmp, username, categories);
    },

    remove : function(cmp, evt, helper){
        var btn = evt.getSource();

        helper.removeRecord(cmp, btn.get('v.value'));
    }
})