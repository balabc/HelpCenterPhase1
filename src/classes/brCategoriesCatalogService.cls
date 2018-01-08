public with sharing class brCategoriesCatalogService {
    
    public static List<brCategoriesCatalogModel> getCatalog(String selectId, String articleType, String dataCategoryName) {
        if (articleType == 'University__kav') {
            brSecurityService.performAccessCheck('read', articleType, new List<String>{
                'KnowledgeArticleId', 'Title', 'Nav_Title__c','Sort_Oder_in_Category__c','PublishStatus'});
        } else {
            brSecurityService.performAccessCheck('read', articleType, new List<String>{
                'KnowledgeArticleId', 'Title', 'Nav_Title__c','Sort_Oder_in_Category__c','PublishStatus','Section_Anchors__c'});
        }
        brSecurityService.performAccessCheck('read', articleType.replace('__kav','') + '__DataCategorySelection', new List<String>{
                'ParentId','DataCategoryGroupName','DataCategoryName'});

        List<brCategoriesCatalogModel> catCatalogList = new List<brCategoriesCatalogModel>();
        List<sObject> articlesList = brCategoriesCatalogServiceSelector.getArticles(articleType);
        List<sObject> catsList = brCategoriesCatalogServiceSelector.getArticleCategories(articleType);   
        
        Boolean isNumeric = (articleType == 'Learning__kav');
        
        List<brArticleModel> articles = new List<brArticleModel>();
        for(sObject k : articlesList) {
            brArticleModel am = new brArticleModel();
            am.UrlName = String.valueOf(k.get('UrlName'));
            if(k.get('Nav_Title__c') != null) {
                am.title = String.valueOf(k.get('Nav_Title__c')); 
            } else {
                am.title = String.valueOf(k.get('Title'));
            }
            if(selectId != null) {
                Id selId = null;
                try {
                    selId = Id.valueOf(selectId);
                } catch(Exception e) {
                    selId = null;
                }
                if(selId == Id.valueOf(String.valueOf(k.get('Id')))) {
                    am.active = true;
                } else {
                    am.active = false;
                }               
            } else {
                am.active = false;
            }
            
            try {
                if(String.valueOf(k.get('Section_Anchors__c')).length() > 0) {
                    List<String> anchors = String.valueOf(k.get('Section_Anchors__c')).split(';');
                    String result = '<ul class="doc-nav__list doc-nav__list-view-sub">';
                    for(Integer li = 0; li < anchors.size(); li++) {
                        result = result + '<li class="doc-nav__item doc-nav__item-view-sub">' + '<a class="doc-nav__link doc-nav__link-view-sub" href=\'#'+anchors[li].split(':')[1]+'\'>'+ anchors[li].split(':')[0] +'</a>' + '</li>';
                    }                               
                    result = result + '</ul>';
                    am.articleSections = result;                
                }         
            } catch (Exception e) {}
            am.id = String.valueOf(k.get('KnowledgeArticleId'));
            am.article_id = String.valueOf(k.get('id'));
            Set<String> cats = new Set<String>();
            for(Integer i = 0; i < catsList.size(); i++) {
                if(String.valueOf(catsList[i].get('ParentId')) == String.valueOf(k.get('Id'))) {
                    cats.add(String.valueOf(catsList[i].get('DataCategoryName')));
                }
            }
            am.categories = cats;
            articles.add(am);
        }     
        Map<String,Map<String,Map<String,List<String>>>> categoryHierarchy = brCategoryService.getCategoryHierarchy(dataCategoryName);
        Map<String, String> catNameMap = brCategoryService.getAllCategoriesMap(dataCategoryName);
        for(String key : categoryHierarchy.keySet()) {
            brCategoriesCatalogModel ccm = new brCategoriesCatalogModel();
            ccm.id = key;
            ccm.isNumeric = isNumeric;
            ccm.name = catNameMap.get(key);
            
            List<brCategoriesCatalogModel> categories = new List<brCategoriesCatalogModel>();
            
            
            if(categoryHierarchy.get(key).keySet().size() > 0) {
                for(String subkey : categoryHierarchy.get(key).keySet()) {                    
                    brCategoriesCatalogModel subccm = new brCategoriesCatalogModel();
                    subccm.id = subkey;
                    subccm.name = catNameMap.get(subkey);                      
                    List<brCategoriesCatalogModel> subcategories = new List<brCategoriesCatalogModel>();
                    if(categoryHierarchy.get(key).get(subkey).keySet().size() > 0) {                         
                        for(String subsubkey : categoryHierarchy.get(key).get(subkey).keySet()) {
                            brCategoriesCatalogModel subsubccm = new brCategoriesCatalogModel();
                            subsubccm.id = subsubkey;
                            subsubccm.name = catNameMap.get(subsubkey); 
                            subcategories.add(subsubccm);                       
                        }
                    } 
                    subccm.categories = subcategories;
                    categories.add(subccm);           
                }
            }
            ccm.categories = categories;
            catCatalogList.add(ccm);
        }     
                           
        for(brArticleModel am : articles) {
            for(brCategoriesCatalogModel ccm : catCatalogList) {
                
                if(am.categories.contains(ccm.id)) {
                    ccm.articles.add(am);
                    if(am.active == true) {                            
                        ccm.active = true;                                     
                    }                    
                } else {
                    for(brCategoriesCatalogModel subccm : ccm.categories) {
                        if(am.categories.contains(subccm.id)) {                         
                            subccm.articles.add(am);
                            if(am.active == true) {                            
                                subccm.active = true;
                                ccm.active = true;                                     
                            }                             
                        } else {
                            for(brCategoriesCatalogModel subsubccm : subccm.categories) {
                               if(am.categories.contains(subsubccm.id)) { 
                                   if(am.active == true) {                             
                                       subsubccm.active = true;
                                       subccm.active = true;
                                       ccm.active = true;                                      
                                   }                                
                                   subsubccm.articles.add(am);
                               }
                            }
                        }
                    }
                }
            }
        }              
        return catCatalogList;
    }
    
}