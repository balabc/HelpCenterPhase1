public with sharing class brArticleContentService {

    /**
     * Returns data category and article type
     *
     * {@inheritDoc}
     *
     * @param       articleId	String
     * @return      map with data category and article type
     * @see         Map<String, String>
     */
    public static Map<String, String> getDataForArticle(String articleId) { 
        Map<String, String> result = new Map<String, String>();
        String articleType = Id.valueOf(articleId).getSObjectType().getDescribe().getName();
        String dataCategory = brArticleContentServiceSelector.getDataCategoryByArticleTypeAndId(articleType, articleId);
        
        result.put('articleType', articleType);
        result.put('dataCategory', dataCategory);
        
        return result;
    }

    /**
     * Returns counts for each category by article type
     *
     * {@inheritDoc}
     *
     * @param       articleType		String 
     * @return      map with counts for each category
     * @see         Map<String, Integer>
     */
    public static Map<String, Integer> getCountForEachCategory(String articleType) {
        Map<String, Integer> result = new Map<String, Integer>();

        List<sObject> guides = brArticleContentServiceSelector.getAllArticleForGuide();
        List<sObject> articles = null;
        String fcu = null;
        String id = null;
        String idGuide = null;
        Integer count = 0;

        if (guides.size() > 0) {
            for (sObject guide : guides) {
                count = 0;
                id = String.valueOf(guide.get('Id'));
                fcu = String.valueOf(guide.get('First_Chapter_Url__c'));

                idGuide = brArticleContentServiceSelector.getArticleByUrl(fcu, articleType);

                if (idGuide != null) {
                    articles = brArticleContentService.getListArticleInCurrentCategory(idGuide);
                    if (articles != null) {
                        count = articles.size();
                    }
                }

                if (result.containsKey(id)) {
                    result.put(id, count);
                } else {
                    result.put(id, count);
                }

            }
        }

        return result;
    }

    /**
     * Returns content for article by article id
     *
     * {@inheritDoc}
     *
     * @param       articleId   String
     * @return      model for article
     * @see         brArticleModel
     */
    public static brArticleModel getArticleContent(String articleId) {
        brArticleModel article = new brArticleModel();
        article.item = brArticleContentServiceSelector.getArticleById(articleId);
        article.id = articleId;
        article.articleType = Id.valueOf(articleId).getSObjectType().getDescribe().getName();

        return article;
    }
    
    /**
     * Returns artiles in current category by article id
     *
     * {@inheritDoc}
     *
     * @param       articleId   String
     * @return      list articles
     * @see         List<SObject>
     */
    public static List<SObject> getListArticleInCurrentCategory(String articleId) {
        String articleType = Id.valueOf(articleId).getSObjectType().getDescribe().getName();

        String dataCategory = brArticleContentServiceSelector.getDataCategoryNameByArticleId(articleId, articleType);
        List<SObject> items = brArticleContentServiceSelector.getArticleListInDataCategory(articleType);
        List<String> ids = new List<String>();

        for (SObject item : items) {
            if (dataCategory == String.valueOf(item.get('DataCategoryName'))) {
                if (!String.isEmpty(String.valueOf(item.get('ParentId')))) {
                    ids.add(String.valueOf(item.get('ParentId')));
                }
            }
        }

        List<SObject> result = brArticleContentServiceSelector.getArticleListByDataCategory(articleType, ids);

        return result;
    }

}