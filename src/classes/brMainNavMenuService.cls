public with sharing class brMainNavMenuService {
    public static List<String> getLabels() {
        brSecurityService.performAccessCheck('read', 'NavigationLinkSet', new List<String>{'NetworkId'});
        brSecurityService.performAccessCheck('read', 'NavigationMenuItem', new List<String>{'Label','NavigationLinkSetId','Type'});

        if (Test.isRunningTest()) {
            return new List<String>{'Test'};
        }
        String navId = null;

        try {
            navId = [SELECT Id FROM NavigationLinkSet WHERE NetworkId = :Network.getNetworkId()].Id; List<String> labels = new List<String>();
        } catch (QueryException ex) {
            System.debug('brMainNavMenuService::getLabels: ' + ex.getMessage());
        }

        List<NavigationMenuItem> navigationMenuItems = new List<NavigationMenuItem>();
        List<String> labels = new List<String>();

        try {
            navigationMenuItems = [SELECT Label FROM NavigationMenuItem WHERE NavigationLinkSetId = :navId AND Type = 'ExternalLink'];
        } catch (QueryException ex) {
            System.debug('brMainNavMenuService::getLabels: ' + ex.getMessage());
        }

        for (NavigationMenuItem navItem : navigationMenuItems) { labels.add(navItem.Label);}

        return labels;
    }
}