public with sharing class brFeedItemService {
    
    public static Integer getFeedItemCount() {
		List<brFeedItemModel> items = new List<brFeedItemModel>();
		List<SObject> topics = brFeedItemServiceSelector.getTopics();
		Set<Id> topicIds = new Set<Id>();
		for (SObject top : topics) {
			topicIds.add(Id.valueOf(String.valueOf(top.get('Id'))));
		}
		
		Set<Id> topicAssignmentIds = new Set<Id>();
		List<SObject> topicAssignments = brFeedItemServiceSelector.getTopicAssignments(topicIds);
		for (SObject top : topicAssignments) {
			topicAssignmentIds.add(Id.valueOf(String.valueOf(top.get('EntityId'))));
		}
        
		List<SObject> topicQuestions = brFeedItemServiceSelector.getQuestionBestComment(topicAssignmentIds, 1000);
        return topicQuestions.size();
    }
		
	public static List<brFeedItemModel> getQuestions() {
		
		List<brFeedItemModel> items = new List<brFeedItemModel>();
		List<SObject> topics = brFeedItemServiceSelector.getTopics();
		Set<Id> topicIds = new Set<Id>();
		for (SObject top : topics) {
			topicIds.add(Id.valueOf(String.valueOf(top.get('Id'))));
		}
		
		Set<Id> topicAssignmentIds = new Set<Id>();
		List<SObject> topicAssignments = brFeedItemServiceSelector.getTopicAssignments(topicIds);
		for (SObject top : topicAssignments) {
			topicAssignmentIds.add(Id.valueOf(String.valueOf(top.get('EntityId'))));
		}	
		
		List<SObject> topicQuestions = brFeedItemServiceSelector.getQuestion(topicAssignmentIds,4);
		for (SObject question : topicQuestions) {
			brFeedItemModel cls = new brFeedItemModel();
			cls.id = String.valueOf(question.get('Id'));
			cls.name = String.valueOf(question.get('Title'));
			items.add(cls);
		}
		
		return items;
		
	}
	
}