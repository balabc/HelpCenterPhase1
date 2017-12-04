public with sharing class brMobileNavMenuCtrl {
	
    @AuraEnabled 
    public static List<brCommunity_Menu_Map__mdt> getMetaDataMenuByArticleType(String articleType) {
        return brNavigationMenuItemService.getMetaDataMenuByArticleType(articleType);
    }
    
    @AuraEnabled 
    public static List<List<SObject>> getArticle(String url) {
        return brNavigationMenuItemService.getArticleByUrl(url);
    }
    
    @AuraEnabled
    public static List<brPhoneSupportList__c> getPhoneList () {
        List<brPhoneSupportList__c> phoneList = [SELECT Country__c,Id,Name,Order__c,Phone__c FROM brPhoneSupportList__c ORDER BY Order__c ASC];
        return phoneList;
    }    
    
    @AuraEnabled
    public static brLeaderboardModel getUserInfo () {
    	return brUserService.getUserInfo();
    }
    
    @AuraEnabled
    public static List<brNavigationMenuItemModel> getNavigationMenu () {
    	return brNavigationMenuItemService.getNavigationMenu();
    }
    
}