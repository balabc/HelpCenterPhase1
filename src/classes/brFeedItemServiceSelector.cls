public with sharing class brFeedItemServiceSelector {

    /**
     * Returns topics
     *
     * {@inheritDoc}
     *
     * @return      topics list
     * @see         List<SObject>
     */
    public static List<SObject> getTopics() {
        List<SObject> topics = [
                SELECT id
                FROM Topic
        ];
        return topics;
    }

    /**
     * Returns assignments topics and list ids
     *
     * {@inheritDoc}
     *
     * @param       ids     Set<Id>
     * @return      assignments list
     * @see         List<SObject>
     */
    public static List<SObject> getTopicAssignments(Set<Id> ids) {
        List<SObject> topicAssignments = [
                SELECT Id, NetworkId, TopicId, Topic.Name, EntityId, EntityKeyPrefix
                FROM TopicAssignment
                WHERE TopicId IN :ids
                LIMIT 1000
        ];
        return topicAssignments;
    }

    /**
     * Returns questions with the best comment and question must exist in array ids
     *
     * {@inheritDoc}
     *
     * @param       ids         Set<Id>
     * @param       limitSql    Integer
     * @return      questions list
     * @see         List<SObject>
     */
    public static List<SObject> getQuestionBestComment(Set<Id> ids, Integer limitSql) {
        List<SObject> questions = new List<SObject>();
        questions = [
                SELECT id, Title
                FROM FeedItem
                WHERE id IN :ids AND BestCommentId != null
                ORDER BY CreatedDate DESC
                limit :limitSql
        ];
        return questions;
    }

    /**
     * Returns questions when question must exist in array ids
     *
     * {@inheritDoc}
     *
     * @param       ids         Set<Id>
     * @param       limitSql    Integer
     * @return      questions list
     * @see         List<SObject>
     */
    public static List<SObject> getQuestion(Set<Id> ids, Integer limitSql) {
        List<SObject> questions = [
                SELECT id, Title
                FROM FeedItem
                WHERE id IN :ids
                ORDER BY CreatedDate DESC
                limit :limitSql
        ];
        return questions;
    }

}