({
    processCrumbs: function(component, event) {
        try {
            var action = component.get("c.getBreadCrumbsData"),
            recordId = component.get("v.recordId");
            action.setParams({
            	fullurl : window.location.href,
            	recordId : recordId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var output = response.getReturnValue();
                    //console.log('crumbsDEBUG:', output.debug);
                    component.set("v.breadCrumbHome", output.homeCrumb);
                    component.set("v.breadCrumbRoot", output.rootCrumb);
                    component.set("v.breadCrumbParent", output.parentCrumb);
                    component.set("v.breadCrumbSubItems", output.subItems);
                    component.set("v.isReady", true);
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log("Errors: ", errors);
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }catch(e){
            console.log('tryE:', e);
        }
    },
    toggleCrumbs: function(component) {
        var crumbPics = document.getElementsByClassName('breadcrumbs__dropdown');
        for(var i=0;crumbPics.length>i;i++){
            crumbPics[i].classList.toggle('breadcrumbs__dropdown--active');
        }
        var crumbList = document.getElementsByClassName('breadcrumbs__dropdown-trigger-text');
        for(var i=0;crumbPics.length>i;i++){
            crumbList[i].classList.toggle('breadcrumbs__dropdown-trigger-text--active');
        }
    },
    closeCrumbs: function(component) {
        console.log('closeCrumbs');
        try{
            var crumbPics = document.getElementsByClassName('breadcrumbs__dropdown');
            for(var i=0;crumbPics.length>i;i++){
                crumbPics[i].classList.remove('breadcrumbs__dropdown--active');
            }
            var crumbList = document.getElementsByClassName('breadcrumbs__dropdown-trigger-text');
            for(var i=0;crumbPics.length>i;i++){
                crumbList[i].classList.remove('breadcrumbs__dropdown-trigger-text--active');
            }
        }catch(e){
            console.log('mouseOutListener tryE:', e);
        }
    },
    mouseOutListener: function(component) {
        try{
            var targetListId = 'crumbsSubMenu';
            var crumbs = component.find('crumbsSubMenu');
            var cmpThis = this;
            if(typeof crumbs != 'undefined'){
                crumbs.getElement().addEventListener("mouseleave", function( event ) {
                    setTimeout(function() {
                        cmpThis.closeCrumbs(component);
                    }, 500);
                }, false);
            }
        }catch(e){
            console.log('mouseOutListener tryE:', e);
        }
    }
})