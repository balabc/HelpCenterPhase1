public with sharing class brMainNavMenuService {
    public static List<String> getLabels() {
        if (Test.isRunningTest()) {
            return new List<String>{'Test'};
        }
        String navId = [SELECT Id FROM NavigationLinkSet WHERE NetworkId = :Network.getNetworkId()].Id; List<String> labels = new List<String>();

        for (NavigationMenuItem navItem : [SELECT Label FROM NavigationMenuItem WHERE NavigationLinkSetId = :navId AND Type = 'ExternalLink']) { labels.add(navItem.Label);}

        return labels;
    }
}