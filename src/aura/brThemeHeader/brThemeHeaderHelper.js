
({
    retrieveInitData : function(component){//BIG-71 fix
        try{
            function getCookieValue(a) {
                var b = document.cookie.match('(^|;)\\s*' + a + '\\s*=\\s*([^;]+)');
                return b ? b.pop() : '';
            }
            var valTerm = getCookieValue('searchTerm');
            if(valTerm !== 'underfined'){
				setTimeout(
                    function(){
                        component.set('v.search', decodeURIComponent(valTerm));
                    }
                    ,200
                );				
            }
        }catch(e){
            //console.error(e.message);
        }
    }
})