public with sharing class brMobileNavMenuCtrl {

    /**
     * Returns list meta data by article type
     *
     * {@inheritDoc}
     *
     * @param       articleType     String
     * @return      meta data
     * @see         List<brCommunity_Menu_Map__mdt>
     */
    @AuraEnabled 
    public static List<brCommunity_Menu_Map__mdt> getMetaDataMenuByArticleType(String articleType) {
        return brNavigationMenuItemService.getMetaDataMenuByArticleType(articleType);
    }

    /**
     * Returns article by url in all categories
     *
     * {@inheritDoc}
     *
     * @param       url     String
     * @return      article
     * @see         List<List<SObject>>
     */
    @AuraEnabled 
    public static List<List<SObject>> getArticle(String url) {
        return brNavigationMenuItemService.getArticleByUrl(url);
    }

    /**
     * Returns phone list
     *
     * {@inheritDoc}
     *
     * @return      phone list
     * @see         List<brPhoneSupportList__c>
     */
    @AuraEnabled
    public static List<brPhoneSupportList__c> getPhoneList () {
        List<brPhoneSupportList__c> phoneList = [SELECT Country__c,Id,Name,Order__c,Phone__c FROM brPhoneSupportList__c ORDER BY Order__c ASC];
        return phoneList;
    }

    /**
     * Returns user information
     *
     * {@inheritDoc}
     *
     * @return      user info
     * @see         brLeaderboardModel
     */
    @AuraEnabled
    public static brLeaderboardModel getUserInfo () {
    	return brUserService.getUserInfo();
    }

    /**
     * Returns navigation menu
     *
     * {@inheritDoc}
     *
     * @return      navigation menu
     * @see         List<brNavigationMenuItemModel>
     */
    @AuraEnabled
    public static List<brNavigationMenuItemModel> getNavigationMenu () {
    	return brNavigationMenuItemService.getNavigationMenu();
    }
    
}