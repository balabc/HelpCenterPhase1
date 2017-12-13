public with sharing class brCommunitySpotlightModel {

    @AuraEnabled
    public String id {get; set;}

    @AuraEnabled
    public String name {get; set;}

    @AuraEnabled
    public Integer score {get; set;}

    @AuraEnabled
    public String authority {get; set;}

    @AuraEnabled
    public Integer posts {get; set;}

    @AuraEnabled
    public Integer comments {get; set;}

    @AuraEnabled
    public Integer likes {get; set;}

    @AuraEnabled
    public String sPhotoUrl {get; set;}

    @AuraEnabled
    public String mPhotoUrl {get; set;}

    @AuraEnabled
    public String fPhotoUrl {get; set;}

}