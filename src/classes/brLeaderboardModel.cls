public with sharing class brLeaderboardModel {
    
    @AuraEnabled 
    public String name {get; set;} 
    
    @AuraEnabled 
    public String score {get; set;} 
       
    @AuraEnabled 
    public String reputationLevel {get; set;}  
    
    @AuraEnabled   
    public String photoUrl {get; set;}    
}