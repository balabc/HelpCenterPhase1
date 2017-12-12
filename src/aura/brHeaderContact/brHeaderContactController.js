({
    hideMe : function(component, event, helper) {
        var contactPanel = document.getElementsByClassName( 'header__contact' )[0];//TODO: possible bug if structure will change
        contactPanel.classList.remove( 'header__contact--active' );
        document.getElementById("contact-lvl-2").classList.remove('contact-lvl-2--active');
    },
    showMe : function(component, event, helper) {
        helper.askPageStatus(component);
        try{
            var contactPanel = document.getElementsByClassName( 'header__contact' )[0];//TODO: possible bug if structure will change
            contactPanel.classList.add( 'header__contact--active' );
        }catch(ee){
            console.log(ee.message);
        }
    },
    doInit : function(component, event, helper) {
        helper.fillPhoneList(component);
    },
    openEmailSupport : function(component, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://support.bigcommerce.com/SubmitCase'
        });
        urlEvent.fire();
    },
    openPhoneSupport : function(component){
        document.getElementById("contact-lvl-2").classList.add('contact-lvl-2--active');
    },
    closePhoneSupport : function(component){
        document.getElementById("contact-lvl-2").classList.remove('contact-lvl-2--active');
    },
    openAskCommunity : function(component){//deprecated?
        console.log('openAskCommunity');
    },
    openLiveChat : function(component, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": 'https://support.bigcommerce.com/apex/SupportLiveAgentPreChatPage'
        });
        urlEvent.fire();
    }
})