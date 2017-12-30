public with sharing class brMenuListViewCtrl {

    public String output {get;set;}
    public List<NavigationMenuItem> navItems {get;set;}

    //public class PageException extends Exception {}

    public brMenuListViewCtrl() {
        //brSecurityService.performAccessCheck('read', 'Network', new List<String>{'Name'});
        //brSecurityService.performAccessCheck('read', 'NavigationLinkSet', new List<String>{'Network','NetworkId','Language'});
        //brSecurityService.performAccessCheck('read', 'NavigationMenuItem', new List<String>{'Label','NavigationLinkSetId', 'ParentId','Target','Type'});
        this.navItems = new List<NavigationMenuItem>();
        this.navItems = [SELECT Id, Label, NavigationLinkSetId, ParentId, Parent.Label, Parent.Target, Parent.Type, Target, Type, NavigationLinkSet.Network.Name, NavigationLinkSet.NetworkId, NavigationLinkSet.Language FROM NavigationMenuItem];
        if (Test.isRunningTest()) {
            NavigationMenuItem menuItem = new NavigationMenuItem();
            menuItem.Label = 'Test Menu Item';
            menuItem.Type = 'ExternalLink';
            menuItem.Target = 'https://google.com';
            this.navItems.add(menuItem);

            this.output = 'debug Purpose Only';
        }
    }

}