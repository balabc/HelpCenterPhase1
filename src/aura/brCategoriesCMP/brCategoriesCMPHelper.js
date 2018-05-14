({
    changeData: function(component) {
        this.getResponse(component);
    },

    getResponse: function(component) {
        var action = component.get("c.getCatalog"), 
            selectId = component.get('v.data.id'),
            articleType = component.get('v.data.objectName');

        action.setParams({
            articleType: articleType
        });

        var fSelectCategory = function(id, data) {
            var flag_selected = false,
                c1, c2, c3;
            c1 = data;
            for (var ck1 in c1) {
                if (c1[ck1].articles.length > 0) {
                    for (var i1 in c1[ck1].articles) {
                        //console.log(c1[ck1].articles[i1]);
                        if ((c1[ck1].articles[i1].article_id === id)) {
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
                            if ((c2[ck2].articles[i2].article_id === id)) {
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
                                if ((c3[ck3].articles[i3].article_id === id)) {
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

        action.setBackground();
        action.setStorable();

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();

                fSelectCategory(selectId, data);
                component.set("v.items", data);

            } else {
               //console.log(response);
            }
        });
        $A.enqueueAction(action);
    }
})