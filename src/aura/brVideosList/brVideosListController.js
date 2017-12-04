({
    doInit: function (cmp, event, helper) {
        var action = cmp.get('c.getVideoArticles');

        action.setCallback(this, function (response) {
            var state = response.getState(),
                videoArticles = response.getReturnValue();

            if (state === 'SUCCESS') {
                var pageNumbers = [],
                    countVideoArticles = videoArticles.length,
                    videosPerPage = cmp.get('v.videosPerPage'),
                    countAllPages = (countVideoArticles%videosPerPage==0?countVideoArticles/videosPerPage:countVideoArticles/videosPerPage+1);

                for (var i=1;i<countAllPages;i++) {
                    pageNumbers.push(i);
                }

                if (pageNumbers.length > 1) {
                    cmp.set('v.pageNumbers', pageNumbers);
                }
                cmp.set('v.videoArticles', videoArticles);
                cmp.set('v.currentPageNumber', 1);
                helper.setVideoArticlesForCurrentPage(cmp);
            } else {
                console.log('callback error: doInit in brVideosListController.js');
            }
        });

        $A.enqueueAction(action);
    },
    setVideosPage: function (cmp, event, helper) {
        var pageNumber = event.getParam("pageNumber");
        cmp.set('v.currentPageNumber', pageNumber);
        helper.setVideoArticlesForCurrentPage(cmp);
    },
    showPrevVideos: function (cmp, event, helper) {
        cmp.set('v.currentPageNumber', cmp.get('v.currentPageNumber')-1);
        helper.setVideoArticlesForCurrentPage(cmp);
    },
    showNextVideos: function (cmp, event, helper) {
        cmp.set('v.currentPageNumber', cmp.get('v.currentPageNumber')+1);
        helper.setVideoArticlesForCurrentPage(cmp);
    }
})