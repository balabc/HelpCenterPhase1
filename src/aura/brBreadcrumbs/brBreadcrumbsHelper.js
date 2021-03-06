({
    processCrumbs: function(component, event) {
        try {
            var action = component.get("c.getBreadCrumbsData"),
            recordId = component.get("v.recordId");
            action.setParams({
            	fullurl : window.location.href,
            	recordId : recordId
            });

            action.setBackground();
            action.setStorable();

            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var output = response.getReturnValue();

                    component.set("v.breadCrumbHome", output.homeCrumb);
                    component.set("v.breadCrumbRoot", output.rootCrumb);
                    component.set("v.breadCrumbParent", output.parentCrumb);
                    component.set("v.breadCrumbSubItems", output.subItems);

                    var cmpThis = this;
                    setTimeout(function(){
                        component.set("v.isReady", true);
                        cmpThis.mouseOutListener(component);
                    }, 500);

                } else if (state === "ERROR") {
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
        }catch(e){
        }
    },
    toggleCrumbs: function(component) {
        try{
            var crumbPics = document.getElementsByClassName('breadcrumbs__dropdown');
            for(var i=0;crumbPics.length>i;i++){
                crumbPics[i].classList.toggle('breadcrumbs__dropdown--active');
            }
            var crumbList = document.getElementsByClassName('breadcrumbs__dropdown-trigger-text');
            for(var i2=0;crumbPics.length>i2;i2++){
                crumbList[i2].classList.toggle('breadcrumbs__dropdown-trigger-text--active');
            }
            component.set("v.isInternalClick", 'true');
            var isOpen = (crumbList[0].classList.contains('breadcrumbs__dropdown-trigger-text--active'))?"true":"false";
            component.set("v.isOpen", isOpen);
        }catch(e){
        }
    },
    closeCrumbs: function(component) {
        try{
            var crumbPics = document.getElementsByClassName('breadcrumbs__dropdown');
            for(var i=0;crumbPics.length>i;i++){
                crumbPics[i].classList.remove('breadcrumbs__dropdown--active');
            }
            var crumbList = document.getElementsByClassName('breadcrumbs__dropdown-trigger-text');
            for(var i2=0;crumbPics.length>i2;i2++){
                crumbList[i2].classList.remove('breadcrumbs__dropdown-trigger-text--active');
            }
            var isOpen = (crumbList[0].classList.contains('breadcrumbs__dropdown-trigger-text--active'))?"true":"false";
            component.set("v.isOpen", isOpen);
            component.set('v.isOutside','true');
        }catch(e){
        }
    },
    mouseOutListener: function(component) {
        try{
            var crumbs = component.find("crumbsSubMenu");

            var cmpThis = this;
            if(typeof crumbs !== 'undefined'){
                crumbs.getElement().addEventListener("mouseleave", function( event ) {
                    component.set('v.isOutside','true');
                }, false);
                crumbs.getElement().addEventListener("mouseenter", function( event ) {
                    component.set('v.isOutside','false');
                }, false);
            }else{

            }
            window.addEventListener("click", function( event ) {
                try{
                    var isInternalClick = component.get('v.isInternalClick');
                    var isOpen = component.get('v.isOpen');
                    var isOutside = component.get('v.isOutside');

                    if(isOpen === 'true' && isOutside === 'true' && isInternalClick === 'false'){
                        cmpThis.closeCrumbs(component);
                    }
                    component.set('v.isInternalClick','false');
                }catch(e){
                }
            }, false);

        }catch(e){
        }
    }
})