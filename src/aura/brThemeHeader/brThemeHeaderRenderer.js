({
	afterRender: function (component, helper) {
        this.superAfterRender();
        
        var funcResizeMobile = function() {  
            var body_classes = document.body.classList,
                class_is_mobile = 'is-mobile';
            if (window.innerWidth < 993) {
                if (!body_classes.contains(class_is_mobile)) {  
                    body_classes.add(class_is_mobile);
                }
            } else {
                body_classes.remove(class_is_mobile);
            }  
        }; 
        funcResizeMobile();
        window.addEventListener('resize', funcResizeMobile);
        
    }
})