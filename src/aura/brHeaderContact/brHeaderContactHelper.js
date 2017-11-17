({
    initMessageListener : function(component){
        try{
            window.addEventListener("message", function(e) {
                var messageObject = JSON.parse(e.data);
                console.log('###messageObject:', messageObject);

                if(messageObject['action'] == 'page-status-ready'){
                    component.set('v.frameStatusReady', true);
                }
                if(messageObject['action'] == 'page-status'){
                    //messageObject['description']
                    //messageObject['indicator']
                }

            });
        }catch(e){
            console.log('Exeption', e);
        }
    },
    askPageStatus : function(component){
        var ready = component.get('v.frameStatusReady');
        var frameID = component.get('v.frameID');
        var frameURL = component.get('v.frameURL');
        //console.log('ready:', ready);
        if(ready){
            try{
                var frameWindow = document.getElementById(frameID);
                if(frameWindow != null){
                    frameWindow.contentWindow.postMessage('what-status', frameURL);//?
                }else{
                    console.log('iframe var is null');
                }
            }catch(ex){
                console.log(ex);
            }
        }else{
            console.log('iframe seems NOT READY');
        }
    }
})