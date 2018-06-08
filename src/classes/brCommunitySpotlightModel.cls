public with sharing class brCommunitySpotlightModel {

    /**
     * id
     */
    @AuraEnabled
    public String id {get; set;}

    /**
     * name
     */
    @AuraEnabled
    public String name {get; set;}

    /**
     * score
     */
    @AuraEnabled
    public Integer score {get; set;}

    /**
     * authority / level
     */
    @AuraEnabled
    public String authority {get; set;}

    /**
     * posts
     */
    @AuraEnabled
    public Integer posts {get; set;}

    /**
     * comments
     */
    @AuraEnabled
    public Integer comments {get; set;}

    /**
     * likes
     */
    @AuraEnabled
    public Integer likes {get; set;}

    /**
     * small user photo
     */
    @AuraEnabled
    public String sPhotoUrl {get; set;}

    /**
     * medium user photo
     */
    @AuraEnabled
    public String mPhotoUrl {get; set;}

    /**
     * full user photo
     */
    @AuraEnabled
    public String fPhotoUrl {get; set;}

}