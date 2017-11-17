
({
    /*
    afterScriptsLoaded : function(component, event, helper) {
        console.log('afterScriptsLoaded');
    },
    */
    hideMe : function(component, event, helper) {
        //console.log('hideMe');
        var contactPanel = document.getElementsByClassName( 'header__contact' )[0];
        contactPanel.classList.remove( 'header__contact--active' );
    },
    showMe : function(component, event, helper) {
        //console.log('showMe');
        helper.askPageStatus(component);
        try{
            var contactPanel = document.getElementsByClassName( 'header__contact' )[0];
            //console.log('showMecontactPanel', contactPanel);
            contactPanel.classList.add( 'header__contact--active' );
        }catch(ee){
            console.log(ee.message);
        }
        /*var params = event.getParam('arguments'); if (params) { var message = params.message; return message; }*/
    },
    doInit : function(component, event, helper) {
        //console.log('HeaderContact init');
        helper.initMessageListener(component);

        //setTimeout(function(){//tmp
        //    helper.askPageStatus(component);
        //}, 5000);

    }
})