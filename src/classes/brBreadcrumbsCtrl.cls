public with sharing class brBreadcrumbsCtrl {

    @AuraEnabled
    public static List<Map<String,String>> doStaff( String fullurl, String recordId) {//String prefix, String pathname,
        String tmpOutput = '';

        List<Map<String,String>> bredcrumbs = new List<Map<String,String>>();

        String pathname = '';
        String baseURL = '';
        if (fullurl.contains('/s/') ) {
            pathname = '/' + fullurl.substringAfter('/s/');
            bredcrumbs.add(new Map<String, String>{'label' => Label.hbrCommunityHome,'type' => 'home','url' => fullurl.substringBefore('/s/') + '/s/','active' => '1'});//TODO:hey
            baseURL = fullurl.substringBefore('/s/') + '/s';
        }

        if (String.isBlank(recordId) && fullurl.contains('#') ) {
            recordId = fullurl.substringAfter('#');
            tmpOutput += ' detected-ID:' + recordId;
        }

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

        NavigationMenuItem parentMenuItem = getMenuItemByTarget(target);
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

            String url = '';//(parentMenuItem.Target != null)?(baseURL + parentMenuItem.Parent.Target):'';
            String rootTarget = getTargetByMenuId(parentMenuItem.Parent.Id);
            url = (rootTarget != null && rootTarget != 'null')?(baseURL + rootTarget):'';
            tmpOutput += ' getTargetByMenuId: '+ url + '(' + parentMenuItem.Parent.Id + ')';
            bredcrumbs.add(new Map<String, String>{'label' => parentMenuItem.Parent.Label,'type' => 'root','url' => url,'active' => 'true', 'listViewId'=>'', 'itemtype'=>parentMenuItem.Parent.Type});

            url = '';
            bredcrumbs.add(new Map<String, String>{'label' => parentMenuItem.Label,'type' => 'parent','url' => url,'active' => 'true', 'listViewId'=>'', 'itemtype'=>parentMenuItem.Type});

            tmpOutput += ' onSameLevel:';
            List<NavigationMenuItem> sameLevelItems = getChildrenMenuItems(parentMenuItem.parentId);
            tmpOutput += ' getChildrenMenuItems: (' + parentMenuItem.parentId + ')';
            for (NavigationMenuItem item : sameLevelItems) {
                tmpOutput += item.Label + ' | ';
                String selected = (parentMenuItem.Label == item.Label) ? 'true' : 'false';

                String itemURL = (item.Type == 'InternalLink') ? baseURL : '';
                itemURL += (item.Target != null && item.Target != 'null') ? item.Target : '';
                if (item.Type == 'MenuLabel'){
                    String tmpTarget = getTargetByMenuId(item.Id);
                    itemURL = (tmpTarget != null && tmpTarget != 'null') ? (baseURL + tmpTarget) : '';
                }
                String listViewId = (item.Type == 'SalesforceObject')?getObjectListViewId(item.Target):'';
                tmpOutput += ' listViewId:' + listViewId + '|';
                bredcrumbs.add(new Map<String, String>{'label' => item.Label,'type' => 'subitem','url' => itemURL,'active' => selected, 'listViewId'=>listViewId, 'itemtype'=>item.Type});
            }
        }
        //tmpOutput += ' NetworkID: ' + System.Network.getNetworkId();//current network ID

        bredcrumbs.add(new Map<String, String>{'label' => tmpOutput,'type' => 'debug','url' => '#','active' => 'false'});

        return bredcrumbs;
    }

    public static String getTargetByObjectName(String objectName){
        try{
            return [SELECT Menu_Target__c FROM brCommunity_Menu_Map__mdt WHERE Object_Name__c = :objectName].Menu_Target__c;
        }catch (Exception e){
            return null;
        }
    }

    public static String getMenuIdByTarget(String target){
        try{
            return [SELECT Menu_Item_Id__c FROM brCommunity_Category_Menu_Map__mdt WHERE Target__c = :target].Menu_Item_Id__c;
        }catch (Exception e){
            return null;
        }
    }
    public static String getTargetByMenuId(String menuItemId){
        try{
            return [SELECT Target__c FROM brCommunity_Category_Menu_Map__mdt WHERE Menu_Item_Id__c = :menuItemId].Target__c;
        }catch (Exception e){
            return null;
        }
    }
    public static String getObjectListViewId(String sObjectName){
        try{
            return [SELECT Id FROM ListView WHERE SobjectType  = :sObjectName LIMIT 1].Id;
        }catch (Exception e){
            return null;
        }
    }

    public static NavigationMenuItem getMenuItemByID(String menuID){
        List<NavigationMenuItem> items = [SELECT Id,Label,NavigationLinkSetId,ParentId,Parent.Label,Parent.Target,Parent.Type,Target,Type FROM NavigationMenuItem WHERE Id = :menuID];
        return (items.size()>0)?items.get(0):null;
    }
    public static NavigationMenuItem getMenuItemByTarget(String inputTarget){
        //System.debug('SELECT Id,Label,NavigationLinkSetId,ParentId,Parent.Label,Target,Type FROM NavigationMenuItem WHERE Target = ' + inputTarget);
        List<NavigationMenuItem> items = [SELECT Id,Label,NavigationLinkSetId,ParentId,Parent.Label,Parent.Target,Parent.Type,Target,Type FROM NavigationMenuItem WHERE Target = :inputTarget];
        return (items.size()>0)?items.get(0):null;
    }

    public static List<NavigationMenuItem> getChildrenMenuItems(String parentId){
        //System.debug('SELECT Id,Label,NavigationLinkSetId,ParentId,Parent.Label,Target,Type FROM NavigationMenuItem WHERE ParentId = ' + parentId);
        List<NavigationMenuItem> items = [SELECT Id,Label,NavigationLinkSetId,ParentId,Parent.Label,Parent.Target,Parent.Type,Target,Type FROM NavigationMenuItem WHERE ParentId = :parentId ];//AND Type != 'MenuLabel'
        return items;
    }

}