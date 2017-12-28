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
        try {
            List<SObject> topics = [
                    SELECT id
                    FROM Topic
            ];
            return topics;
        } catch (Exception e) {System.debug(e.getMessage());return null;}
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
        try {
            List<SObject> topicAssignments = [
                    SELECT Id, NetworkId, TopicId, Topic.Name, EntityId, EntityKeyPrefix
                    FROM TopicAssignment
                    WHERE TopicId IN :ids
                    LIMIT 1000
            ];
            return topicAssignments;
        } catch (Exception e) {System.debug(e.getMessage());return null;}
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
        try {
            List<SObject> questions = new List<SObject>();
            questions = [
                    SELECT id, Title
                    FROM FeedItem
                    WHERE id IN :ids AND BestCommentId != null
                    ORDER BY CreatedDate DESC
                    limit :limitSql
            ];
            return questions;
        } catch (Exception e) {System.debug(e.getMessage());return null;}
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
        try {
            List<SObject> questions = [
                    SELECT id, Title
                    FROM FeedItem
                    WHERE id IN :ids
                    ORDER BY CreatedDate DESC
                    limit :limitSql
            ];
            return questions;
        } catch (Exception e) {System.debug(e.getMessage());return null;}
    }

}