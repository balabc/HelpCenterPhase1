({
    updatePageStatusData : function(component){
        var statusRAW = component.get('v.statusIndicator');
        var newStatusClass = '';
        switch (true) {
          case statusRAW.includes('none'):
            newStatusClass = 'bg--success';
            break;
          case statusRAW.includes('minor'):
            newStatusClass = 'bg--warning';
            break;
          case statusRAW.includes('major'):
            newStatusClass = 'bg--partial-danger';
            break;
          case statusRAW.includes('critical'):
            newStatusClass = 'bg--danger';
            break;
        }
        component.set('v.statusClass', newStatusClass);
    },
    checkPageStatus : function(component){
        try{
            var statusPageId = component.get('v.statusPageId');
            var xmlHttp = new XMLHttpRequest();
            xmlHttp.open( "GET", 'https://' + statusPageId + '.statuspage.io/api/v2/status.json');

            xmlHttp.onload = function (e) {
              if (xmlHttp.readyState === 4) {
                if (xmlHttp.status === 200) {
                    var messageObject = JSON.parse(xmlHttp.responseText);
                    if(xmlHttp.status === 200){
                        component.set('v.statusMessage', messageObject['status']['description']);
                        component.set('v.statusIndicator', messageObject['status']['indicator']);
                        component.set('v.minutesSinceRefresh', 0);//restart count
                    }
                }
              }
            };
            xmlHttp.onerror = function (e) {
            };
            xmlHttp.send( null );
        }catch(e){
        }
    },
    timeInc : function(component){
        var currentVal = component.get('v.minutesSinceRefresh');
        component.set('v.minutesSinceRefresh', currentVal + 1);
    }
})