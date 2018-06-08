public with sharing class brCategoriesCatalogServiceSelector {

    public static List<SObject> getArticles(String articleType) {

        try {
            List<SObject> articles = Database.query('SELECT Id, KnowledgeArticleId, Title, Nav_Title__c, UrlName,' +
                    '(SELECT DataCategoryName, DataCategoryGroupName FROM DataCategorySelections)' +
                    'FROM ' + articleType + ' WHERE PublishStatus = \'Online\'' +
                    'ORDER BY Sort_Oder_in_Category__c ASC NULLS LAST LIMIT 2000');
            return articles;
        } catch (Exception e) { System.debug(e.getMessage()); return null; }
    }

}