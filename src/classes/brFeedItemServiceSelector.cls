public without sharing class brFeedItemServiceSelector {
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
    public static Integer getQuestionBestComment(Integer limitSql) {
        Integer questionsCount = 0;
        try {
            questionsCount = [
                    SELECT COUNT()
                    FROM FeedItem
                    WHERE NetworkScope = :brNetwork.getNetworkId() AND Type='QuestionPost'
                             AND BestCommentId != null AND Visibility = 'AllUsers'
                    limit :limitSql
            ];
            return questionsCount;
        } catch (Exception e) {System.debug(e.getMessage());return null;}
    }

    /**
     * Returns questions when question must exist in array ids
     *
     * {@inheritDoc}
     *
     * @param       limitSql    Integer
     * @return      questions list
     * @see         List<SObject>
     */
    public static List<SObject> getQuestion(Integer limitSql) {
        try {
            List<SObject> questions = [
                    SELECT id, Title
                    FROM FeedItem
                    WHERE NetworkScope = :brNetwork.getNetworkId() AND Type='QuestionPost' AND Visibility = 'AllUsers'
                    ORDER BY CreatedDate DESC
                    limit :limitSql
            ];
            return questions;
        } catch (Exception e) {System.debug(e.getMessage());return null;}
    }

}