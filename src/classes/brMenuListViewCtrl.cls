public with sharing class brMenuListViewCtrl {

    public String output {get;set;}
    public List<NavigationMenuItem> navItems {get;set;}

    //public class PageException extends Exception {}

    public brMenuListViewCtrl() {
        this.navItems = new List<NavigationMenuItem>();
        this.navItems = [SELECT Id, Label, NavigationLinkSetId, ParentId, Parent.Label, Parent.Target, Parent.Type, Target, Type, NavigationLinkSet.Network.Name, NavigationLinkSet.NetworkId, NavigationLinkSet.Language FROM NavigationMenuItem];
        //this.output = 'test|';
        //for(NavigationMenuItem item :navItems){
        //    this.output += '\n' + item.Id + ' ' +item.Label + ' ' + item.Target;
        //}
        //this.output += '';
    }

}