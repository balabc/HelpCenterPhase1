({
    getData : function(component, outVar, method, params) {
        var action = component.get(method);
        if (params !== false)
            action.setParams(params);

        action.setStorable();

        action.setCallback(this, function(response) {
            var state = response.getState(),
                data;
            if (state === "SUCCESS") {
                data = response.getReturnValue();
               //console.log(data);
                component.set(outVar, data);
            }
        });
        $A.enqueueAction(action);
    },
    initSlider: function() {
        var slidesPerView = 6;
        
        if (!$A.util.isUndefinedOrNull(window.mySwiper))
            window.mySwiper.destroy(true, true);
        
        if (window.innerWidth > 992) {
            slidesPerView = 6;
        } else if (window.innerWidth < 410) {
            slidesPerView = 1;
        } else if (window.innerWidth < 770) {
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
    },
    setClickOnUser: function () {
        var classname = document.getElementsByClassName("carousel__item"),
            self = this,
            onClick = function(event) {
                var el = self.getDataIdFromEvent(event.target),
                    navEvt = $A.get("e.force:navigateToSObject");
                
                if (el !== false) {
                    navEvt.setParams({
                        "recordId": el.getAttribute('data-id')
                    });
                    navEvt.fire();
                }
                
                
                
            };
        
        for (var i = 0; i < classname.length; i++) {
            classname[i].removeEventListener('click', onClick, false);
            classname[i].addEventListener('click', onClick, false);
        }
    },
    getDataIdFromEvent: function(el) {
        if (el.getAttribute('data-id') !== null) {
            return el;
        } else {
            if (!$A.util.isUndefinedOrNull(el.parentElement) && !$A.util.isEmpty(el.parentElement)) {
                return this.getDataIdFromEvent(el.parentElement);
            } else {
                return false;
            }
        }
    }
})