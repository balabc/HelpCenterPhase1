
({
    retrieveInitData : function(component, helper){//BIG-71 fix
        this.getCookieValue(component, 'searchTerm');
    },

    getCookieValue : function(component, a){
        var b = document.cookie.match('(^|;)\\s*' + a + '\\s*=\\s*([^;]+)'),
            valTerm = b ? b.pop() : '';

        if (valTerm !== 'undefined'){
            setTimeout(
                function(){
                    component.set('v.search', decodeURIComponent(valTerm));
                }
                ,200
            );
        }
    }
})