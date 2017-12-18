public with sharing class brArticleContentController {

    /**
     * Returns data category and article type
     *
     * {@inheritDoc}
     *
     * @param       articleId   article id that we will look for
     * @return      map with data category and article type
     * @see         Map<String, String>
     */
	@AuraEnabled 
    public static Map<String, String> getDataForArticle(String articleId) { 
        return brArticleContentService.getDataForArticle(articleId);
    }

    /**
     * Returns data model for an article
     *
     * {@inheritDoc}
     *
     * @param       articleId   article id that we will look for
     * @return      data model for an article
     * @see         brArticleModel
     */
	@AuraEnabled
    public static brArticleModel getArticleContent(String articleId) {
        return brArticleContentService.getArticleContent(articleId);
    }

    /**
     * Returns articles for category
     *
     * {@inheritDoc}
     *
     * @param       articleId   article id that id from what start search
     * @return      articles for current category
     * @see         List<SObject>
     */
    @AuraEnabled
    public static List<SObject> getListArticleInCurrentCategory(String articleId) {
        return brArticleContentService.getListArticleInCurrentCategory(articleId);
    }

}