public with sharing class brNavigationMenuItemModel {

    /**
     * id
     */
    @AuraEnabled
    public String id { get; set; }

    /**
     * label
     */
    @AuraEnabled
    public String label { get; set; }

    /**
     * parent id
     */
    @AuraEnabled
    public String parentId { get; set; }

    /**
     * position for order
     */
    @AuraEnabled
    public Integer position { get; set; }

    /**
     * data category name
     */
    @AuraEnabled
    public String dataCategory { get; set; }

    /**
     * object name or article type
     */
    @AuraEnabled
    public String objectName { get; set; }

    /**
     * target can containt url or id
     */
    @AuraEnabled
    public String target { get; set; }

    /**
     * type
     */
    @AuraEnabled
    public String type { get; set; }

    /**
     * status the existence of a submenu
     */
    @AuraEnabled
    public Boolean hasSubMenu { get; set; }

    /**
     * submenu
     */
    @AuraEnabled
    public List<brNavigationMenuItemModel> subMenu { get; set; }

    /**
     * icon
     */
    @AuraEnabled
    public String icon { get; set; }

}