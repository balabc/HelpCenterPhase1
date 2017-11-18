
({
    updatePageStatusData : function(component){
        var statusRAW = component.get('v.statusIndicator');
        var newStatusClass = '';
        //console.log('statusRAW', statusRAW);
        switch (true) {
          case statusRAW.includes('none'):
            newStatusClass = 'bg--success';
            break;
          //case statusRAW.includes('none'):
          //  newStatusClass = 'bg--default';
          //  break;
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
        //console.log('newStatusClass', newStatusClass);
        component.set('v.statusClass', newStatusClass);
    },
    checkPageStatus : function(component){
        var statusPageId = component.get('v.statusPageId');
        var xmlHttp = new XMLHttpRequest();
        xmlHttp.open( "GET", 'https://' + statusPageId + '.statuspage.io/api/v2/status.json', false );
        xmlHttp.send( null );
        var messageObject = JSON.parse(xmlHttp.responseText);
        //console.log('status', xmlHttp.status, 'mObj', messageObject);
        if(xmlHttp.status == 200){
            //console.log('indicator', messageObject['status']['indicator']);
            //console.log('description', messageObject['status']['description']);
            component.set('v.statusMessage', messageObject['status']['description']);
            component.set('v.statusIndicator', messageObject['status']['indicator']);
            component.set('v.minutesSinceRefresh', 0);//restart count
        }
    },
    timeInc : function(component){
        var currentVal = component.get('v.minutesSinceRefresh');
        component.set('v.minutesSinceRefresh', currentVal + 1);
    }
})