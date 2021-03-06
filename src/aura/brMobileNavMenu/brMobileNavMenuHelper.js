({
    getSubMenuUser: function(component, user) {
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
    initMenu: function(component, items) {
        var user = component.get('v.user'),
            objSfdcSite = $A.get('$SfdcSite'),
            locationPage = window.location.pathname;

        objSfdcSite = (!$A.util.isUndefinedOrNull(objSfdcSite)? objSfdcSite.pathPrefix: '');
        locationPage = locationPage.replace(objSfdcSite + '/s', '').replace('/login', '').replace('/profile/', '');

        
        
        if (items.length > 0) {
            items.push({id: 'contact', label: $A.get('$Label.c.lnkContact'), hasSubMenu: true, subMenu: [
                {id: 'ask', label: 'Ask'},
                {id: 'email_support', label: $A.get('$Label.c.hEmailSupport'),type: 'ExternalLink', target: 'https://support.bigcommerce.com/SubmitCase'},
                {id: 'live_chat', label: $A.get('$Label.c.hLiveChat'),type: 'ExternalLink', target: 'https://support.bigcommerce.com/apex/SupportLiveAgentPreChatPage'},
                {id: 'phone_support', label: $A.get('$Label.c.lnkPhoneSupport'), hasSubMenu: true, subMenu: []}
            ]});
            items.push({
                id: 'login', 
                label: $A.get('$Label.c.lnkLogIn'),
                type: 4, 
                has_picture: true,
                picture: '<span class="header-mobile__menu-shape"><img alt="Avatar" src="' + $A.get('$Resource.BigcommerceCommunity') + '/images/group-4.png' + '" srcset="' + $A.get('$Resource.BigcommerceCommunity') + '/images/group-4-2x.png 2x' + '"></span>',
                target: '/s/login/'
            });	 
            
            
            if (user) {
                if (user.logUser === true) {
                    items.pop();
                    items.push({
                        id: 'user', 
                        label: user.name, 
                        has_picture: true,
                        hasSubMenu: true,
                        picture: '<span class="header-mobile__menu-shape"><img src="' + user.photoUrl + '" srcset="' + user.photoUrl + ' 2x" class="header-mobile__menu-userpic" alt=""></span>',
                        subMenu: this.getSubMenuUser(component, user)
                    });	
                }
            }
            
            
            
            if (locationPage.length > 1) {
                if (locationPage.indexOf('CollaborationGroup') > -1) {
                    locationPage = 'CollaborationGroup';
                }
                var menuItems = this.getCurrentLvl(items, locationPage, 'target');
                if (!$A.util.isUndefinedOrNull(menuItems.obj) && !$A.util.isEmpty(menuItems.obj)) {
                    if (menuItems.items.length > 0) {
                        menuItems.parents.pop();
                    	this.setItemsMenu(component, menuItems, true);
                    } else {
              			component.set('v.menuList', items);
                    }
                } else {
                    if (locationPage.indexOf('topic') > -1) {
                        locationPage = 'topic';
                    } else if (locationPage.indexOf('group') > -1) {
                        locationPage = 'group';
                    }
                    else {
                        locationPage = locationPage.split('/');
                        locationPage = locationPage.pop();
                    }
                    this.getArticleByUrl(component, locationPage, items);
                }
            } else {
              	component.set('v.menuList', items);
            }  
            component.set('v.menuItems', items);
        }
    },
    setItemsMenu: function(component, _menuItems, update) {
        update = (update !== 'undefined' ? update : false);
        var menuItems = _menuItems;
        menuItems.parents.push(0);

        if (menuItems.par === undefined || (!!menuItems.obj && !!menuItems.obj.objectName && !!menuItems.obj.isComponent)) {
            component.set('v.currentObj', menuItems.obj);
        } else {
            component.set('v.currentObj', menuItems.par[menuItems.par.length - 1]);
        }

        if (!$A.util.isUndefinedOrNull(menuItems.obj) && !$A.util.isEmpty(menuItems.obj)) {
            if (menuItems.obj.isComponent) {
            	menuItems.items = [];
            	if (update) {
                    component.find('brCategoriesCMP').changeData();
                }
            }
        }
        component.set('v.menuList', menuItems.items);
        component.set('v.menuIds', menuItems.parents.reverse());
    },
    getCurrentLvl: function (menu, value, attr) {
        attr = (attr === undefined)? 'id': attr;
        var res = false;

        if (value !== 0) {
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
                            parents: [menu[i].id],
                            par: [menu[i]]
                        };
                    } else {
                        if (menu[i].hasOwnProperty('subMenu')) {
                            res = this.getCurrentLvl(menu[i].subMenu, value, attr);
                            if (Array.isArray(res.parents)) {
                            	res.parents.push(menu[i].id);
                                res.par.push(menu[i]);
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
        var action = component.get("c.getPhoneList");
        action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.phoneList", data);
            }
        });
        $A.enqueueAction(action);
    },
    getArticleByUrl: function(component, url, items) {
        var obj = {};
        if (url === 'topic') {
            obj.ArticleType = 'Topic';
            this.getMetaDataMenuByArticleType(component, obj, items);
        } else if (url === 'group') {
            obj.ArticleType = 'CollaborationGroup';
            this.getMetaDataMenuByArticleType(component, obj, items);
        } else {
            var action = component.get("c.getArticle"),

                action_meta = component.get("c.getMetaDataMenuByArticleType");
            action.setParams({
                url: url
            });
            action.setStorable();
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue(),
                        objResult, i, j;
                    for (i in data) {
                        if (data[i].length > 0) {
                            for (j in data[i]) {
                                objResult = data[i][j];
                                break;
                            }
                        }
                    }

                    if (!$A.util.isUndefinedOrNull(objResult) && !$A.util.isEmpty(objResult)) {
                        this.getMetaDataMenuByArticleType(component, objResult, items);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    getMetaDataMenuByArticleType: function(component, obj, items) {
        var action = component.get("c.getMetaDataMenuByArticleType");
        action.setParams({
            articleType: obj.ArticleType
        });
        action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data.length > 0) {
                    data = data[0];
                    var menuItems = this.getCurrentLvl(items, data.Menu_Target__c, 'target');
                    if (!$A.util.isUndefinedOrNull(menuItems.obj) && !$A.util.isEmpty(menuItems.obj)) {
                        this.setItemsMenu(component, menuItems, false);
                        if ((obj.ArticleType === 'Topic') || (obj.ArticleType === 'CollaborationGroup')) {
                            menuItems.obj = menuItems.par[menuItems.par.length - 1];
                        } else {
                            menuItems.obj.id = obj.Id;
                        }
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
        action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {  
                var items = response.getReturnValue();
                this.getUserInfo(component, items);
            }
        });
        $A.enqueueAction(action);
    },
    getUserInfo: function(component, items) {
        var action = component.get("c.getUserInfo");
        action.setStorable();
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {      
                component.set("v.user", response.getReturnValue());
            }
            this.initMenu(component, items);
        });
        $A.enqueueAction(action);
    }
})