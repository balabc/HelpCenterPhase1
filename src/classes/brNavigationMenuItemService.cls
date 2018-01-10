public with sharing class brNavigationMenuItemService {

    /**
     * Returns article by url
     *
     * {@inheritDoc}
     *
     * @param       url     String
     * @return      article
     * @see         List<List<SObject>>
     */
    public static List<List<SObject>> getArticleByUrl(String url) {
        brSecurityService.performAccessCheck('read', 'Public__kav', new List<String>{'urlName','ArticleType','PublishStatus'});
        brSecurityService.performAccessCheck('read', 'Learning__kav', new List<String>{'urlName','ArticleType','PublishStatus'});
        brSecurityService.performAccessCheck('read', 'University__kav', new List<String>{'urlName','ArticleType','PublishStatus'});
        brSecurityService.performAccessCheck('search', 'Public__kav',null);
        brSecurityService.performAccessCheck('search', 'Learning__kav',null);
        brSecurityService.performAccessCheck('search', 'University__kav',null);

        List<String> describeList = new List<String>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Set<String> keySet = gd.keySet();
        for (String key : keySet) {
            if (key == 'Public__kav' || key == 'Learning__kav' || key == 'University__kav') {
                Schema.SObjectType objectType = gd.get(key);
                describeList.add(objectType.getDescribe().getName() + ' (Id, urlName, ArticleType WHERE (PublishStatus = \'Online\') AND (urlName = \'' + url + '\'))');
            }
        }

        String articleTypes = String.join(describeList, ', ');
        List<List<SObject>> results = brNavigationMenuItemServiceSelector.getArticle(url, articleTypes);

        return results;
    }

    /**
     * Returns list meta data by article type
     *
     * {@inheritDoc}
     *
     * @param       articleType     String
     * @return      meta data
     * @see         List<brCommunity_Menu_Map__mdt>
     */
    public static List<brCommunity_Menu_Map__mdt> getMetaDataMenuByArticleType(String articleType) {
        brSecurityService.performAccessCheck('read', 'brCommunity_Menu_Map__mdt', new List<String>{'MasterLabel','Data_Category_Group__c',
            'Menu_Target__c','Object_Name__c'});

        List<brCommunity_Menu_Map__mdt> results = brNavigationMenuItemServiceSelector.getMetaDataMenuByArticleType(articleType);
        return results;
    }

    /**
     * Returns navigation menu
     *
     * {@inheritDoc}
     *
     * @return      navigation menu
     * @see         List<brNavigationMenuItemModel>
     */
    public static List<brNavigationMenuItemModel> getNavigationMenu() {
        brSecurityService.performAccessCheck('read', 'NavigationLinkSet', new List<String>{'NetworkId'});
        brSecurityService.performAccessCheck('read', 'NavigationMenuItem', new List<String>{'Label','NavigationLinkSetId','Position',
            'Label','SystemModstamp','Target','TargetPrefs','Type','ParentId'});
        brSecurityService.performAccessCheck('read', 'brCommunity_Menu_Map__mdt', new List<String>{'MasterLabel','Data_Category_Group__c',
            'Menu_Target__c','Object_Name__c'});
        brSecurityService.performAccessCheck('read', 'brCommunity_Category_Menu_Map__mdt', new List<String>{'Menu_Item_Id__c','Target__c'});

        Id communityId = Network.getNetworkId();
        String currentMenuId = brNavigationMenuItemServiceSelector.getCurrentNavigationMenu(communityId);

        List<brNavigationMenuItemModel> itemList = new List<brNavigationMenuItemModel>();
        List<NavigationMenuItem> items = brNavigationMenuItemServiceSelector.getNavigationMenuItem(currentMenuId);
        List<brCommunity_Menu_Map__mdt> metaData = brNavigationMenuItemServiceSelector.getMetaDataMenu();
        List<brCommunity_Category_Menu_Map__mdt> metaDataCategory = brNavigationMenuItemServiceSelector.getMetaDataCategoryMenu();

        if (Test.isRunningTest()) {
            items = new List<NavigationMenuItem>();
            NavigationMenuItem n1 = new NavigationMenuItem();
            n1.ParentId = null;
            n1.label = 'test';
            n1.target = 'test';
            n1.type = 'test';
            n1.position = 213;

            metaDataCategory = new List<brCommunity_Category_Menu_Map__mdt>();
            brCommunity_Category_Menu_Map__mdt m1 = new brCommunity_Category_Menu_Map__mdt();
            metaDataCategory.add(m1);


            metaData = new List<brCommunity_Menu_Map__mdt>();
            brCommunity_Menu_Map__mdt m2 = new brCommunity_Menu_Map__mdt();
            metaData.add(m2);

            NavigationMenuItem n2 = new NavigationMenuItem();
            n2.ParentId = null;

            items.add(n1);
            items.add(n2);
        }

        for (NavigationMenuItem item : items) {

            if (item.ParentId == null) {

                brNavigationMenuItemModel model = new brNavigationMenuItemModel();
                model.id = item.id;
                model.label = item.label;
                model.position = item.position;
                model.target = item.target;
                model.type = item.type;

                for (brCommunity_Category_Menu_Map__mdt metaDataCategoryItem : metaDataCategory) {
                    if (metaDataCategoryItem.Menu_Item_Id__c == model.id) {
                        model.target = metaDataCategoryItem.Target__c;
                        break;
                    }
                }

                List<brNavigationMenuItemModel> subMenuLevel1 = new List<brNavigationMenuItemModel>();

                for (NavigationMenuItem item2 : items) {

                    if (item2.ParentId != null && item2.ParentId == item.id) {
                        brNavigationMenuItemModel modelSub = new brNavigationMenuItemModel();
                        modelSub.id = item2.id;
                        modelSub.label = item2.label;
                        modelSub.position = item2.position;
                        modelSub.target = item2.target;
                        modelSub.type = item2.type;
                        modelSub.parentId = item.id;

                        if (modelSub.target == 'CollaborationGroup') {
                            modelSub.type = 'navigateToList';
                            List<ListView> listviews = [SELECT id FROM ListView WHERE SobjectType  = :modelSub.target LIMIT 1];
                            modelSub.id = listviews[0].id;
                        }

                        for (brCommunity_Menu_Map__mdt metaDataItem : metaData) {
                            if (metaDataItem.Menu_Target__c == item2.target) {
                                if (!String.isEmpty(metaDataItem.Data_Category_Group__c)) {
                                    modelSub.objectName = metaDataItem.Object_Name__c;
                                    modelSub.dataCategory = metaDataItem.Data_Category_Group__c;
                                    modelSub.hasSubMenu = true;
                                }
                                break;
                            }
                        }

                        for (brCommunity_Category_Menu_Map__mdt metaDataCategoryItem : metaDataCategory) {
                            if (metaDataCategoryItem.Menu_Item_Id__c == modelSub.id) {
                                modelSub.target = metaDataCategoryItem.Target__c;
                                break;
                            }
                        }

                        subMenuLevel1.add(modelSub);
                    }

                }

                model.subMenu = subMenuLevel1;

                if (subMenuLevel1.size() > 0) {
                    model.hasSubMenu = true;
                } else {
                    model.hasSubMenu = false;
                }

                itemList.add(model);

            }

        }

        return itemList;
    }

}