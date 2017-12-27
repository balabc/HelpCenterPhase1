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

        brSecurityService.performAccessCheck('read',articleType.replace('__kav','') + '__DataCategorySelection',
        new List<String>{'ParentId','DataCategoryGroupName','DataCategoryName'});

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
        brSecurityService.performAccessCheck('read', 'brGuideItem__mdt', new List<String>{'First_Chapter_Url__c'});
        brSecurityService.performAccessCheck('read', articleType, new List<String>{'UrlName'});

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
        brSecurityService.performAccessCheck('read', 'Public__kav', new List<String>{'Article__c'});
        brSecurityService.performAccessCheck('read', 'Learning__kav', new List<String>{'KnowledgeArticleId', 'Title',
            'Article__c','Guide_Title__c', 'Sort_Oder_in_Category__c','Back_Button_URL__c',
            'Next_Button_Text__c','Next_Button_URL__c'});
        brSecurityService.performAccessCheck('read', 'University__kav', new List<String>{'KnowledgeArticleId', 'Title',
            'Description__c','Additional_Resources__c', 'Next_Video_URL__c','Next_Video_Link_Text__c',
            'Prev_Video_URL__c','Prev_Video_Link_Text__c','Video_URL__c'});

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

        brSecurityService.performAccessCheck('read','Public__kav', new List<String>{'PublishStatus'});
        brSecurityService.performAccessCheck('read','Learning__kav', new List<String>{'PublishStatus'});
        brSecurityService.performAccessCheck('read','University__kav', new List<String>{'PublishStatus'});
        brSecurityService.performAccessCheck('read',articleType.replace('__kav','') + '__DataCategorySelection',
            new List<String>{'ParentId','DataCategoryName'});
        brSecurityService.performAccessCheck('read',articleType,
            new List<String>{'KnowledgeArticleId','Title','Nav_Title__c','Sort_Oder_in_Category__c','PublishStatus'});

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