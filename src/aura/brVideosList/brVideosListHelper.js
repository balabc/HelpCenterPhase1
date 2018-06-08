({
    setVideoArticlesForCurrentPage: function(cmp, event) {
        var videoArticles = cmp.get('v.videoArticles'),
            currentPageNumber = cmp.get('v.currentPageNumber'),
            videosPerPage = cmp.get('v.videosPerPage'),
            videoArticlesForCurrentPage = [];

        if (videoArticles.length <= videosPerPage) {
            cmp.set('v.isPrevious', false);
            cmp.set('v.isNext', false);
        } else if (currentPageNumber === 1) {
            cmp.set('v.isPrevious', false);
            cmp.set('v.isNext', true);
        } else if (currentPageNumber === cmp.get('v.pageNumbers').length){
            cmp.set('v.isPrevious', true);
            cmp.set('v.isNext', false);
        } else {
            cmp.set('v.isPrevious', true);
            cmp.set('v.isNext', true);
        }

        for (var i=0;i<videoArticles.length;i++) {
            if ((i >= (currentPageNumber-1)*videosPerPage) && (i <= videosPerPage*currentPageNumber-1)) {
                videoArticlesForCurrentPage.push(videoArticles[i]);
            }
        }
        cmp.set('v.videoArticlesForCurrentPage', videoArticlesForCurrentPage);
    }
})