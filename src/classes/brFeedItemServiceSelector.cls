public with sharing class brFeedItemServiceSelector {
    public static List<SObject> getTopics() {
    	List<SObject> topics = [SELECT id FROM Topic];
    	return topics;
    }
    public static List<SObject> getTopicAssignments(Set<Id> ids) {
    	List<SObject> topicAssignments = [SELECT  Id, NetworkId, TopicId, Topic.Name, EntityId,  EntityKeyPrefix FROM TopicAssignment WHERE TopicId IN :ids];
    	return topicAssignments;
    }    
    public static List<SObject> getQuestion(Set<Id> ids, Integer limitSql) {
    	List<SObject> questions = [SELECT id, Title FROM FeedItem where id IN :ids ORDER BY CreatedDate DESC limit :limitSql];
    	return questions;
    }     
}