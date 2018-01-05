/**
*     The structure of breadcrumbs:
*
 *    | HomeItem | rootItem | ParentItem |
 *                          | Subitem-1  |
 *                          | Subitem-N  |
 *
 *
 */
public with sharing class brBreadcrumbsCtrl {
    /**
     *  Single portion of data for breadcrumbs
     */
    public class BreadCrumbItem{
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String url {get; set;}
        @AuraEnabled
        public String active {get; set;}
        @AuraEnabled
        public String listViewId {get; set;}
        @AuraEnabled
        public String itemtype {get; set;}

        public BreadCrumbItem(){
            label = '';
            url = '';
            active = 'false';
            listViewId = '';
            itemtype = '';
        }
    }
    /**
     * Full data scope for breadcrumbs component
     */
    public class BreadCrumbsData{
        @AuraEnabled
        public BreadCrumbItem homeCrumb {get; set;}
        @AuraEnabled
        public BreadCrumbItem rootCrumb {get; set;}
        @AuraEnabled
        public BreadCrumbItem parentCrumb {get; set;}
        @AuraEnabled
        public List<BreadCrumbItem> subItems {get; set;}
        @AuraEnabled
        public String debug {get; set;}

        public BreadCrumbsData(){
            homeCrumb =  new BreadCrumbItem();
            rootCrumb =  new BreadCrumbItem();
            parentCrumb =  new BreadCrumbItem();
            subItems =  new LIst<BreadCrumbItem>();
            debug = '';
        }
    }

    /**
     *
     *
     * @param fullurl       current full url of page that displays breadcrumb component
     * @param recordId      recordId returned by force:hasRecordId interface
     *
     * @return              BreadCrumbsData
     */
    @AuraEnabled
    public static BreadCrumbsData getBreadCrumbsData( String fullurl, String recordId) {
        System.debug(recordId);
        String tmpOutput = '';
        BreadCrumbsData breadCrumbsData = new BreadCrumbsData();

        String pathname = '';
        String baseURL = '';
        fullurl = fullurl.replace('#myideas', '');
        fullurl = fullurl.replace('#list', '');

        if (fullurl.contains('/s/') ) {
            pathname = '/' + fullurl.substringAfter('/s/');

            breadCrumbsData.homeCrumb.label = Label.hbrCommunityHome;
            breadCrumbsData.homeCrumb.url = fullurl.substringBefore('/s/') + '/s/';
            breadCrumbsData.homeCrumb.active = 'true';

            baseURL = fullurl.substringBefore('/s/') + '/s';
        }

        if (String.isBlank(recordId) && fullurl.contains('#') ) {
            recordId = fullurl.substringAfter('#');
            tmpOutput += ' detected-ID:' + recordId;
        }
        NavigationMenuItem parentMenuItem = null;
        String target = '';
        String varObjectType = '';
        if (String.isNotBlank(recordId)) {
            Id objectId = Id.valueOf(recordId);
            varObjectType = String.valueOf(objectId.getsObjectType());
            tmpOutput += ' obj:' + varObjectType;

            if (varObjectType == 'ListView') {
                if (pathname.contains('CollaborationGroup')) {//TODO:need detect other objects (separate / and try all variants?)
                    target = 'CollaborationGroup';
                }
            } else {
                target = getTargetByObjectName(varObjectType);
            }
        }else if (pathname.contains('CollaborationGroup')) {
            target = 'CollaborationGroup';
        }else if (pathname.contains('group')) {
            //target = 'group';
            String tmpStr = pathname.substringAfter('/group/');
            tmpOutput += '#2tmp: ' + tmpStr;
            if(tmpStr.length() >= 18){
                target = '/group/' + tmpStr.left(18);
                String tmpMenuId = getMenuIdByTarget(target);//from Category Metadata (2d menu meta)
                tmpOutput += ' #2target-' + target + ' ;menuId:' + tmpMenuId + '#';
                if(tmpMenuId != null) {
                    parentMenuItem = getMenuItemByID(tmpMenuId);
                }
            }
            if (parentMenuItem == null) {
                target = 'CollaborationGroup';
            }
        }else{
            tmpOutput += ' pathname:' + pathname;
            if (pathname.contains('/s/') ) {
                target = '/' + fullurl.substringAfter('/s/');//check if there any '/' present
                tmpOutput += ' detected-Target:' + target;
            }else{
                if(pathname.countMatches('/') == 1 && pathname.left(1) == '/'){
                    target = pathname;
                    tmpOutput += ' detected-Target(case2):' + target;
                }
            }
            target = target.replace('#', '');//TODO: is it worth to use regular exp in this case?
            target = target.replace('?', '');
        }
        tmpOutput += ' target:' + target;

        parentMenuItem = getMenuItemByTarget(target);
        if (parentMenuItem == null) {
            String menuId = getMenuIdByTarget(target);//from Category Metadata (2d menu meta)
            tmpOutput += ' #target-' + target + ' ;menuId:' + menuId + '#';
            if(menuId != null){
                parentMenuItem = getMenuItemByID(menuId);
            }
        }

        if (parentMenuItem != null) {
            tmpOutput += ' rootParent:' + parentMenuItem.Parent.Label;
            tmpOutput += ' parent:' + parentMenuItem.Label;

            String url = '';
            String rootTarget = getTargetByMenuId(parentMenuItem.Parent.Id);
            url = (rootTarget != null && rootTarget != 'null')?(baseURL + rootTarget):'';
            tmpOutput += ' getTargetByMenuId: '+ url + '(' + parentMenuItem.Parent.Id + ')';

            breadCrumbsData.rootCrumb.label = parentMenuItem.Parent.Label;
            breadCrumbsData.rootCrumb.url = url;
            breadCrumbsData.rootCrumb.active = 'true';
            breadCrumbsData.rootCrumb.itemtype = parentMenuItem.Parent.Type;

            url = '';
            breadCrumbsData.parentCrumb.label = parentMenuItem.Label;
            breadCrumbsData.parentCrumb.url = url;
            breadCrumbsData.parentCrumb.active = 'true';
            breadCrumbsData.parentCrumb.itemtype = parentMenuItem.Type;

            tmpOutput += ' onSameLevel:';
            List<NavigationMenuItem> sameLevelItems = getChildrenMenuItems(parentMenuItem.parentId);
            tmpOutput += ' getChildrenMenuItems: (' + parentMenuItem.parentId + ')';
            for (NavigationMenuItem item : sameLevelItems) {
                String selected = (parentMenuItem.Label == item.Label) ? 'true' : 'false';
                String itemURL = (item.Type == 'InternalLink') ? baseURL : '';
                itemURL += (item.Target != null && item.Target != 'null') ? item.Target : '';
                if (item.Type == 'MenuLabel'){
                    String tmpTarget = getTargetByMenuId(item.Id);
                    itemURL = (tmpTarget != null && tmpTarget != 'null') ? (baseURL + tmpTarget) : '';
                }
                String listViewId = (item.Type == 'SalesforceObject')?getObjectListViewId(item.Target):'';

                BreadCrumbItem itemSubMenu = new BreadCrumbItem();
                itemSubMenu.label = item.Label;
                itemSubMenu.url = itemURL;
                itemSubMenu.active = selected;
                itemSubMenu.listViewId = listViewId;
                itemSubMenu.itemtype = item.Type;
                breadCrumbsData.subItems.add(itemSubMenu);
            }
        }
        //tmpOutput += ' NetworkID: ' + System.Network.getNetworkId();//current network ID
        breadCrumbsData.debug = tmpOutput;

        return breadCrumbsData;
    }
    /**
     * brCommunity_Menu_Map__mdt stores mapping between object type and menu item target
     *
     * @param objectName   String sObjectType
     *
     * @return  string target menu item value like "/something"
     */
    public static String getTargetByObjectName(String objectName){
        brSecurityService.performAccessCheck('read','brCommunity_Menu_Map__mdt', new List<String>{'Menu_Target__c','Object_Name__c'});

        try{
            return [SELECT Menu_Target__c FROM brCommunity_Menu_Map__mdt WHERE Object_Name__c = :objectName].Menu_Target__c;
        }catch (Exception e){
            return null;
        }
    }
    /**
     * brCommunity_Category_Menu_Map__mdt stores mapping between menu category (which is not clickable) and target (page target url)
     *
     * @param target  "/something"
     *
     * @return  menu item id (of category menu item)
     */
    public static String getMenuIdByTarget(String target){
        brSecurityService.performAccessCheck('read','brCommunity_Category_Menu_Map__mdt', new List<String>{'Menu_Item_Id__c','Target__c'});

        try{
            return [SELECT Menu_Item_Id__c FROM brCommunity_Category_Menu_Map__mdt WHERE Target__c = :target].Menu_Item_Id__c;
        }catch (Exception e){
            return null;
        }
    }
    /**
     * brCommunity_Category_Menu_Map__mdt stores mapping between menu category (which is not clickable) and target (page target url)
     *
     * @param menuItemId
     *
     * @return  menu like target value "/something" that will be used in building URL
     */
    public static String getTargetByMenuId(String menuItemId){
        brSecurityService.performAccessCheck('read','brCommunity_Category_Menu_Map__mdt', new List<String>{'Target__c','Menu_Item_Id__c'});

        try{
            return [SELECT Target__c FROM brCommunity_Category_Menu_Map__mdt WHERE Menu_Item_Id__c = :menuItemId].Target__c;
        }catch (Exception e){
            return null;
        }
    }
    /**
     * Get any available list view of current object
     *
     * @param sObjectName   String of sObjectType
     *
     * @return   Id of object listveiw
     */
    public static String getObjectListViewId(String sObjectName){
        brSecurityService.performAccessCheck('read','ListView', new List<String>{'SobjectType'});

        try{
            return [SELECT Id FROM ListView WHERE SobjectType  = :sObjectName LIMIT 1].Id;
        }catch (Exception e){
            return null;
        }
    }
    /**
     * Get single menu item data from NavigationMenuItem based on Id match
     *
     * @param menuID
     *
     * @return
     */
    public static NavigationMenuItem getMenuItemByID(String menuID){
        brSecurityService.performAccessCheck('read','NavigationMenuItem', new List<String>{'Label','NavigationLinkSetId','ParentId','Target','Type'});

        List<NavigationMenuItem> items = [SELECT Id,Label,NavigationLinkSetId,ParentId,Parent.Label,Parent.Target,Parent.Type,Target,Type
                                            FROM NavigationMenuItem WHERE Id = :menuID AND NavigationLinkSetId = :getNavigationLinkSetId()];
        return (items.size()>0)?items.get(0):null;
    }
    /**
     * Get single menu item data from NavigationMenuItem based on target match
     *
     * @param inputTarget
     *
     * @return
     */
    public static NavigationMenuItem getMenuItemByTarget(String inputTarget){
        brSecurityService.performAccessCheck('read','NavigationMenuItem', new List<String>{'Label','NavigationLinkSetId','ParentId','Target','Type'});

        List<NavigationMenuItem> items = [SELECT Id,Label,NavigationLinkSetId,ParentId,Parent.Label,Parent.Target,Parent.Type,Target,Type
                                            FROM NavigationMenuItem WHERE Target = :inputTarget AND NavigationLinkSetId = :getNavigationLinkSetId()];
        return (items.size()>0)?items.get(0):null;
    }
    /**
     * Get list of menu items data from NavigationMenuItem based on ParentId match
     *
     * @param parentId
     *
     * @return
     */
    public static List<NavigationMenuItem> getChildrenMenuItems(String parentId){
        brSecurityService.performAccessCheck('read','NavigationMenuItem', new List<String>{'Label','NavigationLinkSetId','ParentId','Target','Type'});

        List<NavigationMenuItem> items = [SELECT Id,Label,NavigationLinkSetId,ParentId,Parent.Label,Parent.Target,Parent.Type,Target,Type
                                            FROM NavigationMenuItem WHERE ParentId = :parentId AND NavigationLinkSetId = :getNavigationLinkSetId()];//AND Type != 'MenuLabel'
        return items;
    }

    public static String getNavigationLinkSetId(){
        if(Test.isRunningTest()) return [SELECT Id FROM NavigationLinkSet LIMIT 1].Id;

        return [SELECT Id FROM NavigationLinkSet WHERE NetworkId = :brNetwork.getNetworkId() LIMIT 1].Id;
    }

}