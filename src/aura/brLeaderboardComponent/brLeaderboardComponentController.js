({
	doInit : function(component, event, helper) {
        helper.getData(component, 'v.userLeaderboard', 'c.getUserLeaderboard', false);
	},
    jsLoaded : function(component, event, helper) {
        window.mySwiper = new Swiper ('.swiper-container', {
            slidesPerView: 'auto'
        });
        window.addEventListener('resize', function(){
            window.mySwiper.update();
        } , false );
        
    }
})