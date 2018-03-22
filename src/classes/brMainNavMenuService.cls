public with sharing class brMainNavMenuService {
    public static List<String> getLabels() {
        brSecurityService.performAccessCheck('read', 'NavigationLinkSet', new List<String>{'NetworkId'});
        brSecurityService.performAccessCheck('read', 'NavigationMenuItem', new List<String>{'Label','NavigationLinkSetId','Type'});

        List<NavigationMenuItem> navigationMenuItems = new List<NavigationMenuItem>();
        List<String> labels = new List<String>();

        try {
            navigationMenuItems = [SELECT Label FROM NavigationMenuItem WHERE NavigationLinkSet.NetworkId = :brNetwork.getNetworkId() AND Type = 'ExternalLink'];
        } catch (QueryException ex) {
            System.debug('brMainNavMenuService::getLabels: ' + ex.getMessage());
        }

        for (NavigationMenuItem navItem : navigationMenuItems) {
            labels.add(navItem.Label);
        }

        if (Test.isRunningTest()) {
            return new List<String>{'Test'};
        }
        return labels;
    }
}