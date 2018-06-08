public with sharing class brLeaderboardModel {
    
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
    public String score {get; set;} 
       
    /**
     * authority / level
     */
    @AuraEnabled 
    public String reputationLevel {get; set;}  
    
    /**
     * user photo
     */
    @AuraEnabled   
    public String photoUrl {get; set;}    
    
    /**
     * his logged
     */
    @AuraEnabled   
    public Boolean logUser {get; set;}
    
}