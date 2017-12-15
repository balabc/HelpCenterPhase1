public with sharing class brNavigationMenuItemService {

    public static List<List<SObject>> getArticleByUrl(String url) {
        List<String> describeList = new List<String>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Set<String> keySet = gd.keySet();
        for (String key : keySet) {
            Schema.SObjectType objectType = gd.get(key);
            if (key.endsWith('kav')) {
                describeList.add(objectType.getDescribe().getName() + ' (Id, urlName, ArticleType WHERE (PublishStatus = \'Online\') AND (urlName = \'' + url + '\'))');
            }
        }

        String articleTypes = String.join(describeList, ', ');
        List<List<SObject>> results = brNavigationMenuItemServiceSelector.getArticle(url, articleTypes);

        return results;
    }

    public static List<brCommunity_Menu_Map__mdt> getMetaDataMenuByArticleType(String articleType) {
        List<brCommunity_Menu_Map__mdt> results = brNavigationMenuItemServiceSelector.getMetaDataMenuByArticleType(articleType);
        return results;
    }

    public static List<brNavigationMenuItemModel> getNavigationMenu() {
        List<brNavigationMenuItemModel> itemList = new List<brNavigationMenuItemModel>();
        List<NavigationMenuItem> items = brNavigationMenuItemServiceSelector.getNavigationMenuItem();
        List<brCommunity_Menu_Map__mdt> metaData = brNavigationMenuItemServiceSelector.getMetaDataMenu();
        List<brCommunity_Category_Menu_Map__mdt> metaDataCategory = brNavigationMenuItemServiceSelector.getMetaDataCategoryMenu();

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