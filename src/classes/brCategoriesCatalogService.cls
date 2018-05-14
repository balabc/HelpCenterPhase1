public with sharing class brCategoriesCatalogService {
    
    public static List<brCategoriesCatalogModel> getCatalog(String articleType) {

        if (articleType == 'University__kav') {
            brSecurityService.performAccessCheck('read', articleType, new List<String>{
                'KnowledgeArticleId', 'Title', 'Nav_Title__c','Sort_Oder_in_Category__c','PublishStatus'});
        } else {
            brSecurityService.performAccessCheck('read', articleType, new List<String>{
                'KnowledgeArticleId', 'Title', 'Nav_Title__c','Sort_Oder_in_Category__c','PublishStatus','Section_Anchors__c'});
        }
        brSecurityService.performAccessCheck('read', articleType.replace('__kav','') + '__DataCategorySelection', new List<String>{
                'ParentId','DataCategoryGroupName','DataCategoryName'});

        Map<String, List<brArticleModel>> catsArticlesMap = new Map<String, List<brArticleModel>>();
        List<SObject> articlesList = brCategoriesCatalogServiceSelector.getArticles(articleType);
        String dataCategoryGroupName = '';

        for (SObject ar: articlesList) {
            if(ar.getSObjects('DataCategorySelections') == null) continue;

            if(String.isBlank(dataCategoryGroupName)) {
                dataCategoryGroupName = String.valueOf(articlesList[0].getSObjects('DataCategorySelections')[0].get('DataCategoryGroupName'));
            }

            String dataCategory = String.valueOf(ar.getSObjects('DataCategorySelections')[0].get('DataCategoryName'));

            brArticleModel am = new brArticleModel();
            am.UrlName = String.valueOf(ar.get('UrlName'));

            if(ar.get('Nav_Title__c') != null) {
                am.title = String.valueOf(ar.get('Nav_Title__c'));
            } else {
                am.title = String.valueOf(ar.get('Title'));
            }

            am.id = String.valueOf(ar.get('KnowledgeArticleId'));
            am.article_id = String.valueOf(ar.get('Id'));

            if(!catsArticlesMap.containsKey(dataCategory)) {
                catsArticlesMap.put(dataCategory, new List<brArticleModel>());
            }

            List<brArticleModel> articlesForCategory = catsArticlesMap.get(dataCategory);
            articlesForCategory.add(am);
            catsArticlesMap.put(dataCategory, articlesForCategory);
        }

        List<brCategoriesCatalogModel> catCatalogList = brCategoryService.getAllCategoriesForGroup(dataCategoryGroupName);

        for(brCategoriesCatalogModel ccm : catCatalogList) {
            ccm.isNumeric = (articleType == 'Learning__kav');

            if(catsArticlesMap.containsKey(ccm.id)) {
                ccm.articles = catsArticlesMap.get(ccm.id);
            }

            for(brCategoriesCatalogModel subccm : ccm.categories) {
                if(catsArticlesMap.containsKey(subccm.id)) {
                    subccm.articles = catsArticlesMap.get(subccm.id);
                }

                for(brCategoriesCatalogModel subsubccm : subccm.categories) {
                    if(catsArticlesMap.containsKey(subsubccm.id)) {
                        subsubccm.articles =  catsArticlesMap.get(subsubccm.id);
                    }
                }
            }
        }

        return catCatalogList;
    }
    
}