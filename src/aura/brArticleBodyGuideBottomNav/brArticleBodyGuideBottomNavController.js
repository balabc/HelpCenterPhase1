({
    doInit: function (component, event, helper) {
        console.log(component.get('v.article'));
        helper.getData(component, 'v.listArticles', 'c.getListArticleInCurrentCategory', {
            articleId: component.get('v.article').id
        });
    },
    onChangeList: function (component, event, helper) {
        var prev = undefined,
            next = undefined,
            list = component.get('v.listArticles'),
            articleId = component.get('v.article').id,
            find_i = false;
        if (!!list) {
            if (list.length > 1) {
                for (var i in list) {
                    if (list[i].Id === articleId) {
                        find_i = parseInt(i);
                        break;
                    }
                }

                prev = list[find_i - 1];

                if (list.length > (find_i + 1)) {
                    next = list[find_i + 1];
                }
            }
        }
        component.set('v.prevArticle', prev);
        component.set('v.nextArticle', next);
        console.log(list.length, find_i, prev, next);
    },
    onClick: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject"),
            target = event.target.closest('a');

        navEvt.setParams({
            "recordId": target.dataset.id
        });
        navEvt.fire();
    }
})