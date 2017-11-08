public with sharing class brFeedItemServiceSelector {
    public static List<SObject> getTopics() {
    	List<SObject> topics = [SELECT id FROM Topic];
    	return topics;
    }
    public static List<SObject> getTopicAssignments(Set<Id> ids) {
    	List<SObject> topicAssignments = [SELECT  Id, NetworkId, TopicId, Topic.Name, EntityId,  EntityKeyPrefix FROM TopicAssignment WHERE TopicId IN :ids];
    	return topicAssignments;
    }    
    public static List<SObject> getQuestion(Set<Id> ids) {
    	List<SObject> questions = [SELECT id, Title FROM FeedItem where id IN :ids ORDER BY CreatedDate ASC limit 4];
    	return questions;
    }     
}