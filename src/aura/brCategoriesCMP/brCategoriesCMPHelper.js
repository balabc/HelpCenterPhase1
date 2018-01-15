({
    getCatalogList: function(component) {
        //console.log('[DEBUG] [Helper] brCategoriesCMP:getCatalogList');
        var action = component.get("c.getCatalogList"), 
            articleType = component.get('v.data.objectName'),
            dataCategoryName = component.get('v.data.dataCategory');
        
        action.setParams({ 
            categoryName: 'All',
            articleType: articleType,
            dataCategoryName: dataCategoryName
        });

        action.setStorable();
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var data = response.getReturnValue();
               //console.log(data);
            }
        });
        $A.enqueueAction(action);
    },
    getResponse: function(component) {
        //console.log('[DEBUG] [Helper] brCategoriesCMP:getResponse');
        var action = component.get("c.getCatalog"), 
            selectId = component.get('v.selectedArticleId'),
            articleType = component.get('v.data.objectName'),
            url = component.get('v.data.target'),
            dataCategoryName = component.get('v.data.dataCategory');

        if (!!url) {
            url = url.split('/');
            url = url[url.length - 1];
            //console.log(url);
        }

        action.setParams({
            articleType: articleType,
            dataCategoryName: dataCategoryName
        });

        var fSelectCategory = function(url, id, data) {
            var flag_selected = false,
                c1, c2, c3;
            //console.log(url, id);
            c1 = data;
            for (var ck1 in c1) {
                if (c1[ck1].articles.length > 0) {
                    for (var i1 in c1[ck1].articles) {
                        //console.log(c1[ck1].articles[i1]);
                        if ((c1[ck1].articles[i1].article_id === id) || (c1[ck1].articles[i1].UrlName === url)) {
                            flag_selected = true;
                            c1[ck1].articles[i1].active = true;
                            break;
                        }
                    }
                }
                c2 = c1[ck1].categories;
                for (var ck2 in c2) {
                    if (c2[ck2].articles.length > 0) {
                        for (var i2 in c2[ck2].articles) {
                            //console.log(c2[ck2].articles[i2]);
                            if ((c2[ck2].articles[i2].article_id === id) || (c2[ck2].articles[i2].UrlName === url)) {
                                flag_selected = true;
                                c2[ck2].articles[i2].active = true;
                                break;
                            }
                        }
                    }
                    c3 = c2[ck2].categories;
                    for (var ck3 in c3) {
                        if (c3[ck3].articles.length > 0) {
                            for (var i3 in c3[ck3].articles) {
                                //console.log(c3[ck3].articles[i3]);
                                if ((c3[ck3].articles[i3].article_id === id) || (c3[ck3].articles[i3].UrlName === url)) {
                                    flag_selected = true;
                                    c3[ck3].articles[i3].active = true;
                                    break;
                                }
                            }
                        }
                        if (flag_selected) {
                            c3[ck3].active = true;
                            break;
                        }
                    }
                    if (flag_selected) {
                        c2[ck2].active = true;
                        break;
                    }
                }
                if (flag_selected) {
                    c1[ck1].active = true;
                    break;
                }
            }
        };

        /*if (!!selectId) {
            //console.log(selectId, articleType, dataCategoryName);
            action.setParams({
                //url: url,
                //selectId : selectId,
                articleType: articleType,
                dataCategoryName: dataCategoryName
            });
        } else {
            action.setParams({
                //url: url,
                articleType: articleType,
                dataCategoryName: dataCategoryName
            });
        }*/

        action.setStorable();
               
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var data = response.getReturnValue();
                //console.log(data);
                if (!!selectId) {
                    fSelectCategory(url, selectId, data);
                } else {
                    fSelectCategory(url, selectId, data);
                }
                //console.log(data);
                component.set("v.items", data);

            } else {
               //console.log(response);
            }
        });
        $A.enqueueAction(action);
    }
})