public with sharing class brFeedItemService {
	public static List<brFeedItemModel> getQuestions() {
		List<brFeedItemModel> items = new List<brFeedItemModel>();
		List<SObject> topics = brFeedItemServiceSelector.getTopics();
		Set<Id> topicIds = new Set<Id>();
		for(SObject top : topics) {
			topicIds.add(Id.valueOf(String.valueOf(top.get('Id'))));
		}
		Set<Id> topicAssignmentIds = new Set<Id>();
		List<SObject> topicAssignments = brFeedItemServiceSelector.getTopicAssignments(topicIds);
		for(SObject top : topicAssignments) {
			topicAssignmentIds.add(Id.valueOf(String.valueOf(top.get('EntityId'))));
		}	
		List<SObject> topicQuestions = brFeedItemServiceSelector.getQuestion(topicAssignmentIds);
		for(SObject question : topicQuestions) {
			brFeedItemModel cls = new brFeedItemModel();
			cls.id = String.valueOf(question.get('Id'));
			cls.name = String.valueOf(question.get('Title'));
			items.add(cls);
		}
		return items;
	}
}