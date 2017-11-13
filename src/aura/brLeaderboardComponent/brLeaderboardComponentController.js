({
	doInit: function(component, event, helper) {
        
	},
    
    jsLoaded: function(component, event, helper) {
        helper.initSlider();
        helper.getLeaderboardCommunity(component);
        
        window.addEventListener('resize', function() {
            if (!!window.mySwiper) {
                var slidesPerView = 6;
                
                console.log(window.mySwiper);
                if (window.innerWidth > 992) {
                    slidesPerView = 6;
                } else if (window.innerWidth <= 992) {
                    slidesPerView = 4;
                } else if (window.innerWidth < 810) {
                    slidesPerView = 3;
                } else if (window.innerWidth < 610) {
                    slidesPerView = 2;
                } else if (window.innerWidth < 410) {
                    slidesPerView = 1;
                }
                if (window.mySwiper.params.slidesPerView !== slidesPerView) {
                    window.mySwiper.params.slidesPerView = slidesPerView;
                    window.mySwiper.destroy(false, true);
                    window.mySwiper.init();
                }
            }
        });
        //window.mySwiper.current = window.innerWidth;
    },
    userLeaderboardChange: function(component, event, helper) {
        var data = component.get('v.userLeaderboard');
        window.mySwiper.removeAllSlides();
        data.forEach(function(element){
            window.mySwiper.appendSlide('<div class="column-lg-2 column--pad m-bottom-25 carousel__item">' +
                '<div class="panel-person">' + 
                    '<div class="panel-person__head">' +
                        '<div class="panel-person__icon">' +
                        '<img src="' + element.photoUrl + '" alt="' + element.name + '" />' +
                        '</div>' +
                        '</div>' +
                        '<div class="panel-person__body">' +
                        '<h4 class="h4 panel-person__title truncated">' + element.name + '</h4>' +
                        '<p class="panel-person__text type--xsm truncated">' + element.score + '</p>' +
                        '</div>' +
                        '<div class="panel-person__footer">' +
                        '<a href="javascript:void(0);" class="panel-person__link truncated">' + element.reputationLevel + '</a>' +
                    '</div>' +
                '</div>' +
            '</div>');
        });
        window.mySwiper.destroy(false, true);
        window.mySwiper.init();
    }
})