({
    hideMe : function(component, event, helper) {
        //console.log('hideMe');
        var contactPanel = document.getElementsByClassName( 'header__contact' )[0];//TODO: possible bug if structure will change
        contactPanel.classList.remove( 'header__contact--active' );
        document.getElementById("contact-lvl-2").classList.remove('contact-lvl-2--active');
    },
    showMe : function(component, event, helper) {
        //console.log('showMe');
        helper.askPageStatus(component);
        try{
            var contactPanel = document.getElementsByClassName( 'header__contact' )[0];//TODO: possible bug if structure will change
            //console.log('showMecontactPanel', contactPanel);
            contactPanel.classList.add( 'header__contact--active' );
        }catch(ee){
            console.log(ee.message);
        }
    },
    doInit : function(component, event, helper) {
        helper.fillPhoneList(component);
        //var askButtonCMP = component.get('v.askbutton');
        //askButtonCMP.textContent = 'dddd';
        //component.set('v.askbutton', askButtonCMP);
    },
    openEmailSupport : function(component){
        console.log('openEmailSupport');
    },
    openPhoneSupport : function(component){
        console.log('openPhoneSupport');
        document.getElementById("contact-lvl-2").classList.add('contact-lvl-2--active');
    },
    closePhoneSupport : function(component){
        console.log('closePhoneSupport');
        document.getElementById("contact-lvl-2").classList.remove('contact-lvl-2--active');
    },
    openAskCommunity : function(component){
        console.log('openAskCommunity');
    },
    openLiveChat : function(component){
        console.log('openLiveChat');
    }
})