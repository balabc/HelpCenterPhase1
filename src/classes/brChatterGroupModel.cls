public with sharing class brChatterGroupModel {

    /**
     * chatter group id
     */
    @AuraEnabled
    public String id { get; set; }

    /**
     * chatter group name
     */
    @AuraEnabled
    public String name { get; set; }

}