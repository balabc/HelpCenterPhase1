({
	doInit: function(component, event, helper) {
        
	},
    jsLoaded: function(component, event, helper) {
        window.mySwiper = new Swiper ('.swiper-container', {
            slidesPerView: 4,
      		spaceBetween: 0,
            slideClass: 'carousel__item',
            grabCursor: true,
            init: false
        });
        helper.getData(component, 'v.userLeaderboard', 'c.getUserLeaderboard', false);
        
        window.mySwiper.on('resize', function() {
            if (!!window.mySwiper) {
                if (window.innerWidth > 992) {
                    window.mySwiper.params.slidesPerView = 6;
                    window.mySwiper.destroy(false, true);
                    window.mySwiper.init();
                } else if (window.innerWidth <= 992) {
                    window.mySwiper.params.slidesPerView = 4;
                    window.mySwiper.destroy(false, true);
                    window.mySwiper.init();
                } else if (window.innerWidth < 810) {
                    window.mySwiper.params.slidesPerView = 3;
                    window.mySwiper.destroy(false, true);
                    window.mySwiper.init();
                } else if (window.innerWidth < 610) {
                    window.mySwiper.params.slidesPerView = 2;
                    window.mySwiper.destroy(false, true);
                    window.mySwiper.init();
                }
                
            }
        });
        window.mySwiper.init();
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
        
        window.mySwiper.appendSlide('<div class="column-lg-2 column--pad m-bottom-25 carousel__item">' +
                '<div class="panel-person">' +
                    '<div class="panel-person__head">' +
                        '<div class="panel-person__icon">' +
                        '<img src="/support/profilephoto/7290O000000YjBz/F" alt="test" />' +
                        '</div>' +
                        '</div>' +
                        '<div class="panel-person__body">' +
                        '<h4 class="h4 panel-person__title truncated">test</h4>' +
                        '<p class="panel-person__text type--xsm truncated">test</p>' +
                        '</div>' +
                        '<div class="panel-person__footer">' +
                        '<a href="javascript:void(0);" class="panel-person__link truncated">test</a>' +
                    '</div>' +
                '</div>' +
            '</div>');
        
        window.mySwiper.appendSlide('<div class="column-lg-2 column--pad m-bottom-25 carousel__item">' +
                '<div class="panel-person">' +
                    '<div class="panel-person__head">' +
                        '<div class="panel-person__icon">' +
                        '<img src="/support/profilephoto/7290O000000YjBz/F" alt="test" />' +
                        '</div>' +
                        '</div>' +
                        '<div class="panel-person__body">' +
                        '<h4 class="h4 panel-person__title truncated">test</h4>' +
                        '<p class="panel-person__text type--xsm truncated">test</p>' +
                        '</div>' +
                        '<div class="panel-person__footer">' +
                        '<a href="javascript:void(0);" class="panel-person__link truncated">test</a>' +
                    '</div>' +
                '</div>' +
            '</div>');
        
        window.mySwiper.appendSlide('<div class="column-lg-2 column--pad m-bottom-25 carousel__item">' +
                '<div class="panel-person">' +
                    '<div class="panel-person__head">' +
                        '<div class="panel-person__icon">' +
                        '<img src="/support/profilephoto/7290O000000YjBz/F" alt="test" />' +
                        '</div>' +
                        '</div>' +
                        '<div class="panel-person__body">' +
                        '<h4 class="h4 panel-person__title truncated">test</h4>' +
                        '<p class="panel-person__text type--xsm truncated">test</p>' +
                        '</div>' +
                        '<div class="panel-person__footer">' +
                        '<a href="javascript:void(0);" class="panel-person__link truncated">test</a>' +
                    '</div>' +
                '</div>' +
            '</div>');
        mySwiper.updateSlides();
    }
})