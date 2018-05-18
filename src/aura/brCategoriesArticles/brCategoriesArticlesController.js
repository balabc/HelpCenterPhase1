({
    doInit : function(component, event, helper) {
        var art = component.get('v.article'),
            selectedArticleId = component.get('v.selectedArticleId');
        if (!!art) {
            component.set('v.routeInput', {
                recordId: art.article_id
            });

            if(art.article_id === selectedArticleId) {
                helper.retrieveArticleSections(component, art.article_id);
            }
        }
    },

    changeHeader: function(component, event, helper) {
        if (location.href.indexOf("#") != -1) {
            var header = document.getElementsByClassName('header')[0],
                announcementBlock = document.getElementsByClassName('announcement-block')[0];

            if (announcementBlock != undefined) {
                if (announcementBlock.style.position = 'relative') {
                    announcementBlock.style.position = 'fixed';
                    announcementBlock.style.zIndex = '4';
                }
            }

            window.setTimeout(
                $A.getCallback(function () {
                    header.className += ' header--make-sticky';
                }), 300);
        }
    },

    clickElement: function(component, event, helper) {
        var toggleEvent = component.getEvent("brCategoriesToggleEventHandler"),
            art = component.get('v.article');
        if (!!art) {
            helper.retrieveArticleSections(component, art.article_id);
            toggleEvent.setParams({
                "idRow": 'brCategoriesArticles_' + component.get('v.article').id
            });
            toggleEvent.fire();
        }
    }
})