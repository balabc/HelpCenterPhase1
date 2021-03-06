public with sharing class brArticleContentServiceSelector {

    /**
     * Returns data category for those article type and article id
     *
     * {@inheritDoc}
     *
     * @param       articleType     String
     * @param       articleId       String
     * @return      data category name
     * @see         String
     */
    public static String getDataCategoryByArticleTypeAndId(String articleType, String articleId) { 
    	articleType = articleType.replace('__kav','');
        try {
            List<sObject> cats = Database.query('SELECT id, ParentId, DataCategoryGroupName, DataCategoryName FROM ' + articleType + '__DataCategorySelection WHERE ParentId = \'' + articleId + '\'');
            return String.valueOf(cats[0].get('DataCategoryGroupName'));
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns article by id
     *
     * {@inheritDoc}
     *
     * @param       articleId     String
     * @return      article
     * @see         sObject
     */
    public static sObject getArticleById(String articleId) {
        try {
            String articleType = Id.valueOf(articleId).getSObjectType().getDescribe().getName();
            String queryFields = '';
            String articleBody = '';

            if(articleType == 'Public__kav') {
                queryFields = ',Article__c,Author__c';

            } else if(articleType == 'Learning__kav') {
                queryFields = ',Article__c,Guide_Title__c,Sort_Oder_in_Category__c,Back_Button_URL__c,Next_Button_Text__c,Next_Button_URL__c';

            } else if(articleType == 'University__kav') {
                queryFields = ',Description__c,Additional_Resources__c,Next_Video_URL__c,Next_Video_Link_Text__c,Prev_Video_URL__c,Prev_Video_Link_Text__c,Video_URL__c';
            }

            String q = 'SELECT  KnowledgeArticleId,Title,ArticleNumber,ArticleCreatedById,' +
                                'LastPublishedDate,LastModifiedById,' +
                                'IsVisibleInApp,IsVisibleInPkb,ArticleCaseAttachCount' +
                                + queryFields + ' FROM ' + articleType + ' WHERE Id = \'' + articleId + '\' LIMIT 1';


            SObject article = (sObject) Database.query(q);

            if(articleType == 'Public__kav') {
                articleBody = (String) article.get('Article__c');
                article.put('Article__c', articleBody.replace('/articles/Public/', '/s/article/'));

            } else if(articleType == 'Learning__kav') {
                articleBody = (String) article.get('Article__c');
                article.put('Article__c', articleBody.replace('/articles/Learning/', '/s/article/'));
            }

    	    return article;
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns data category name by article type
     *
     * {@inheritDoc}
     *
     * @param       articleType     String
     * @return      data category name
     * @see         String
     */
    public static List<SObject> getDataCategories(String articleType) {
        String q = 'SELECT DataCategoryName, ParentId FROM ' + articleType.replace('__kav','') + '__DataCategorySelection WHERE Parent.PublishStatus = \'Online\'';
        try {
        return Database.query(q);
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns data category name by article id
     *
     * {@inheritDoc}
     *
     * @param       articleType     String
     * @param       articleId       String
     * @return      data category name
     * @see         String
     */
    public static String getDataCategoryNameByArticleId(String articleId, String articleType) {
        String q = 'SELECT DataCategoryName FROM ' + articleType.replace('__kav','') + '__DataCategorySelection WHERE (ParentId = \'' + articleId + '\') AND (Parent.PublishStatus = \'Online\') LIMIT 1';
        try {
            SObject result = Database.query(q);
            return String.valueOf(result.get('DataCategoryName'));
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns article list in category with this article type
     *
     * {@inheritDoc}
     *
     * @param       articleType     String
     * @return      article list
     * @see         String
     */
    public static List<sObject> getArticleListInDataCategory(String articleType) {
        String q = 'SELECT ParentId, DataCategoryName FROM ' + articleType.replace('__kav','') + '__DataCategorySelection WHERE Parent.PublishStatus = \'Online\'';
        try {
            return Database.query(q);
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns article list by article type and id must contain in list ids
     *
     * {@inheritDoc}
     *
     * @param       articleType     String
     * @param       ids             List<String>
     * @return      article list
     * @see         List<sObject>
     */
    public static List<sObject> getArticleListByDataCategory(String articleType, List<String> ids) {
        String q = 'SELECT KnowledgeArticleId, Title, Nav_Title__c, Id, Sort_Oder_in_Category__c FROM ' + articleType + ' WHERE (PublishStatus = \'Online\') AND (Id IN :ids) ORDER BY Sort_Oder_in_Category__c ASC';
        try {
            return Database.query(q);
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns article list by article type
     *
     * {@inheritDoc}
     *
     * @param       articleType     String
     * @return      article list
     * @see         List<sObject>
     */
    public static List<sObject> getAllArticleByArticleType(String articleType) {
        String q = 'SELECT Id, UrlName FROM ' + articleType + ' WHERE (PublishStatus = \'Online\')';
        try {
            return Database.query(q);
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns guides
     *
     * {@inheritDoc}
     *
     * @return      list guides
     * @see         List<sObject> 
     */
    public static List<sObject> getAllArticleForGuide() {

        if(Test.isRunningTest()) {
            return new List<brGuideItem__mdt>{new brGuideItem__mdt()};
        }

        String q = 'SELECT Id, First_Chapter_Url__c FROM brGuideItem__mdt';
        try {
            return Database.query(q);
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns article id by url name
     *
     * {@inheritDoc}
     *
     * @return      article id
     * @see         String
     */
    public static String getArticleByUrl(String url, String articleType) {
        String q = 'SELECT Id, UrlName  FROM ' + articleType + ' WHERE UrlName = \'' + url + '\' LIMIT 1';
        try {
            List<sObject> result = Database.query(q);
            if (result.size() > 0) {
                return String.valueOf(result[0].get('Id'));
            } else {
                return null;
            }
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns Knowledge Article Id by url name
     *
     * {@inheritDoc}
     *
     * @return      Knowledge Article Id
     * @see         String
     */
    public static String getArticleByUrlKnowledgeArticleId(String url, String articleType) {
        String q = 'SELECT Id, UrlName, KnowledgeArticleId  FROM ' + articleType + ' WHERE UrlName = \'' + url + '\' LIMIT 1';
        try {
            List<sObject> result = Database.query(q);
            if (result.size() > 0) {
                return String.valueOf(result[0].get('Id'));
            } else {
                return null;
            }
        } catch (Exception e) {System.debug(e);return null;}
    }

}