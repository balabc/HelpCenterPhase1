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
            } else if (state === "ERROR") {
                //console.log('callback error: doInit in brVideosListController.js');
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if (errors[0].message === 'access_error') {
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        } else {
                            error_msg = errors[0].message;
                        }
                    }
                }
                if (error_msg.length === 0) {
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
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