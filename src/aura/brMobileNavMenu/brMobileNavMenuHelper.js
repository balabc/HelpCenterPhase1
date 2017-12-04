({
    getSubMenuUser: function(component, user){
        return [                       
            {id: 'profile', label: $A.get('$Label.c.lnkProfile'), type: 'SalesforceObject', target: user.id},
            {id: 'my_messages', label: $A.get('$Label.c.lnkMyMessages'), type: 'InternalLink', target: '/messages/Home'},
            {id: 'my_feed', label: $A.get('$Label.c.lnkMyFeed'), type: 'InternalLink', target: '/feed'},
            {id: 'my_cases', label: $A.get('$Label.c.lnkMyCases'), type: 'InternalLink', target: '/case'},
            {id: 'my_files', label: $A.get('$Label.c.lnkMyFiles'), type: 'InternalLink', target: '/MyFeed'},
            {id: 'settings', label: $A.get('$Label.c.lnkSettings'), type: 'InternalLink', target: '/settings/' + user.id},
            {id: 'log_out', label: $A.get('$Label.c.lnkLogOut'), type: 4, target: '/secur/logout.jsp'}
            
        ];
    },
    setItemsMenu: function(component, _menuItems) {
        var menuItems = _menuItems;
        menuItems.parents.push(0);
        component.set('v.currentObj', menuItems.obj);
        component.set('v.menuList', menuItems.items);
        component.set('v.menuIds', menuItems.parents.reverse());
    },
    getCurrentLvl: function (menu, value, attr) {
        attr = (attr === undefined)? 'id': attr;
        var res = false;
        if (!!value) { 
            for (var i in menu) {
                if (menu.hasOwnProperty(i)) {
                    if (menu[i][attr] === value) {
                        res = {
                            obj: {
                                id: menu[i].id,
                                label: menu[i].label,
                                type: menu[i].type,
                                target: menu[i].target,
                                dataCategory: menu[i].dataCategory,
                                objectName: menu[i].objectName,
                                isComponent: (!!menu[i].dataCategory || !!menu[i].objectName)
                            },
                            items: (menu[i].hasOwnProperty('subMenu')? menu[i].subMenu: menu),
                            parents: [menu[i].id]
                        };
                    } else {
                        if (menu[i].hasOwnProperty('subMenu')) {
                            res = this.getCurrentLvl(menu[i].subMenu, value, attr);
                            if (Array.isArray(res.parents)) {
                            	res.parents.push(menu[i].id);
                            }
                        }
                    }	    
                }
                if (res !== false) {
                    break;
                }
            }
        } else {
            return {
                items: menu,
                is_not_id: true,
                parents: []
            };
        }
        return res;
    },
    fillPhoneList: function(component){
        try {
            var action = component.get("c.getPhoneList");
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    component.set("v.phoneList", data);
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
            
        }catch(e){
            console.log('tryE:', e);
        }
    },
    getUserInfo: function(component) {
        var action = component.get("c.getUserInfo");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {      
                component.set("v.user", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getArticleByUrl: function(component, url) {
        console.log(url);
        var action = component.get("c.getArticle"),
            action_meta = component.get("c.getMetaDataMenuByArticleType");
        action.setParams({ 
            url: url
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {  
                var data = response.getReturnValue(), 
                    obj, i, j;
                for (i in data) {
                    if (data[i].length > 0) {
                        for (j in data[i]) {
                            obj = data[i][j];
                            break;
                        }
                    }
                }
                if (!!obj) {
                    this.getMetaDataMenuByArticleType(component, obj);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getMetaDataMenuByArticleType: function(component, obj) {
        var action = component.get("c.getMetaDataMenuByArticleType");
        action.setParams({
            articleType: obj.ArticleType
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {      
                var data = response.getReturnValue();
                if (data.length > 0) {
                    data = data[0];
                    var items = component.get('v.menuItems'),
                        menuItems = this.getCurrentLvl(items, data.Menu_Target__c, 'target');
                    if (!!menuItems.obj) {
                        this.setItemsMenu(component, menuItems);
                        menuItems.obj.id = obj.Id;
                        component.set('v.currentObj', menuItems.obj);
                        component.find('brCategoriesCMP').changeData();
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    getNavigationMenu: function(component) {
        var action = component.get("c.getNavigationMenu");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {  
                var data = response.getReturnValue();
                component.set("v.menuItems", data);
            }
        });
        $A.enqueueAction(action);
    } 
})