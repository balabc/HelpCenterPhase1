({
	getData : function(component, outVar, method, params) {
        var action = component.get(method);
        if (params !== false)
        	action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState(),
                data;
            if (state === "SUCCESS") {
                data = response.getReturnValue();
                console.log(data);
                component.set(outVar, data);
            }
        });
        $A.enqueueAction(action);
    },
    getLeaderboardCommunity : function(component) {
        var action = component.get('c.getCommunityId');
        action.setCallback(this, function(response) {
            var state = response.getState(),
                id;
            if (state === "SUCCESS") {
                id = response.getReturnValue();
                component.set('v.idCommunity', id);
                this.getData(component, 'v.userLeaderboard', 'c.getUserLeaderboard', {
                    communityId: id
                });
            }
        });
        $A.enqueueAction(action);
    },
    initSlider: function() {
        var slidesPerView = 6;
        
        if (window.innerWidth > 992) {
            slidesPerView = 6;
        } else if (window.innerWidth < 410) {
            slidesPerView = 1;
        } else if (window.innerWidth < 610) {
            slidesPerView = 2;
        } else if (window.innerWidth < 810) {
            slidesPerView = 3;
        } else if (window.innerWidth <= 992) {
            slidesPerView = 4;
        }
        window.mySwiper = new Swiper ('.swiper-container', {
            slidesPerView: slidesPerView,
      		spaceBetween: 0,
            slideClass: 'carousel__item',
            grabCursor: true
        });
    }
})