public with sharing class brNavigationMenuItemServiceSelector {

    /**
     * Returns article by url and article types
     *
     * {@inheritDoc}
     *
     * @param       url             String
     * @param       acticleTypes    String
     * @return      article
     * @see         List<List<SObject>>
     */
    public static List<List<SObject>> getArticle(String url, String acticleTypes) {
        try {
            List<List<SObject>> articles = search.query('FIND \'' + url + '\' RETURNING ' + acticleTypes + '');
            return articles;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    /**
     * Returns menu by id
     *
     * {@inheritDoc}
     *
     * @param       NavigationLinkSetId     String
     * @return      menu
     * @see         List<NavigationMenuItem>
     */
    public static List<NavigationMenuItem> getNavigationMenuItem(String NavigationLinkSetId) {
        try {
            List<NavigationMenuItem> itemList = new List<NavigationMenuItem>();
            itemList = [SELECT id, Label, NavigationLinkSetId, Position, SystemModstamp, Target, TargetPrefs, Type, ParentId FROM NavigationMenuItem WHERE NavigationLinkSetId = :NavigationLinkSetId ORDER BY Position];
            return itemList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    /**
     * Returns current menu
     *
     * {@inheritDoc}
     *
     * @param       communityId     String
     * @return      id current menu
     * @see         String
     */
    public static String getCurrentNavigationMenu(Id communityId) {
        try {
            List<NavigationLinkSet> itemList = [SELECT id, NetworkId FROM NavigationLinkSet WHERE NetworkId = :communityId];
            return String.valueOf(itemList[0].id);
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    /**
     * Returns list meta data for menu
     *
     * {@inheritDoc}
     *
     * @return      list meta data
     * @see         List<brCommunity_Menu_Map__mdt>
     */
    public static List<brCommunity_Menu_Map__mdt> getMetaDataMenu() {
        try {
            List<brCommunity_Menu_Map__mdt> itemList = new List<brCommunity_Menu_Map__mdt>();
            itemList = [SELECT MasterLabel, Data_Category_Group__c, Menu_Target__c, Object_Name__c FROM brCommunity_Menu_Map__mdt];
            return itemList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    /**
     * Returns list meta data for category menu
     *
     * {@inheritDoc}
     *
     * @return      list meta data
     * @see         List<brCommunity_Category_Menu_Map__mdt>
     */
    public static List<brCommunity_Category_Menu_Map__mdt> getMetaDataCategoryMenu() {
        try {
            List<brCommunity_Category_Menu_Map__mdt> itemList = new List<brCommunity_Category_Menu_Map__mdt>();
            itemList = [SELECT Menu_Item_Id__c, Target__c FROM brCommunity_Category_Menu_Map__mdt];
            return itemList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    /**
     * Returns list meta data by article type
     *
     * {@inheritDoc}
     *
     * @param       articleType     String
     * @return      list meta data
     * @see         List<brCommunity_Menu_Map__mdt>
     */
    public static List<brCommunity_Menu_Map__mdt> getMetaDataMenuByArticleType(String articleType) {
        try {
            List<brCommunity_Menu_Map__mdt> itemList = new List<brCommunity_Menu_Map__mdt>();
            itemList = [SELECT MasterLabel, Data_Category_Group__c, Menu_Target__c, Object_Name__c FROM brCommunity_Menu_Map__mdt WHERE Object_Name__c = :articleType];
            return itemList;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }
    
}