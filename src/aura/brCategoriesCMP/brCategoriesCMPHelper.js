({
    getResponse: function(component) {
        var action = component.get("c.getCatalog"),
            selectId = component.get('v.selectedArticleId');
        if (!!selectId) { 
            console.log(selectId);
            action.setParams({ 
                selectId : selectId
            });
        }
        
        /*
        ,
            parseQueryString = function(query) {
                var vars = query.split("&");
                var query_string = {};
                for (var i = 0; i < vars.length; i++) {
                    var pair = vars[i].split("=");
                    // If first entry with this name
                    if (typeof query_string[pair[0]] === "undefined") {
                        query_string[pair[0]] = decodeURIComponent(pair[1]);
                        // If second entry with this name
                    } else if (typeof query_string[pair[0]] === "string") {
                        var arr = [query_string[pair[0]], decodeURIComponent(pair[1])];
                        query_string[pair[0]] = arr;
                        // If third or later entry with this name
                    } else {
                        query_string[pair[0]].push(decodeURIComponent(pair[1]));
                    }
                } 
                return query_string;
            },
            params = parseQueryString(location.hash.substr(2))
        */
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('res',res);
                component.set("v.items", res);
            }
        });
        $A.enqueueAction(action);
    }
})