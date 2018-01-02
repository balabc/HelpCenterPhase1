({
    openPage: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL"),
            findClass = event.target;

        while (findClass.getAttribute('class') !== 'panel-media' && findClass.getAttribute('class') !== 'panel-media p-media') {
            findClass = findClass.parentNode;
        }

        var url = findClass.getAttribute('id');
       //console.log('url: ' + url);

        if (url === 'groups') {
            helper.gotoList(cmp);
        } else if (url === 'userDocs') {
            url = cmp.get('v.userDocsUrl');
        } else if (url === 'devDocs') {
            url = 'https://developer.bigcommerce.com';
        } else {
            url = '/' + url;
        }

        if (url !== 'groups') {
            urlEvent.setParams({"url": url}).fire();
        }
    }
})