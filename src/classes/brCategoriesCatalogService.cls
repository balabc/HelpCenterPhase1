public with sharing class brCategoriesCatalogService {
    
    public static List<brCategoriesCatalogModel> getCatalog(String selectId, String articleType, String dataCategoryName) {
        List<brCategoriesCatalogModel> catCatalogList = new List<brCategoriesCatalogModel>();
        List<sObject> articlesList = brCategoriesCatalogServiceSelector.getArticles(articleType); 
        List<sObject> catsList = brCategoriesCatalogServiceSelector.getArticleCategories(articleType);   
        List<brArticleModel> articles = new List<brArticleModel>();
        for(sObject k : articlesList) {
            brArticleModel am = new brArticleModel();
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
            if(k.get('Article_Sections__c') != null) {
                if(String.valueOf(k.get('Article_Sections__c')).length() > 0) {
                    List<String> anchors = String.valueOf(k.get('Article_Sections__c')).split(';');
                    String result = '<ul>';
                    for(Integer li = 0; li < anchors.size(); li++) {
                        result = result + '<li>' + '<a class=\'anchor\' href=\'#'+anchors[li].split(':')[0]+'\'>'+ anchors[li].split(':')[1] +'</a>' + '</li>'; 
                    }                               
                    result = result + '</ul>';
                    am.articleSections = result;                
                }               
            }            
            am.id = String.valueOf(k.get('KnowledgeArticleId'));
            Set<String> cats = new Set<String>();
            for(Integer i = 0; i < catsList.size(); i++) {
                if(String.valueOf(catsList[i].get('ParentId')) == String.valueOf(k.get('Id'))) {
                    cats.add(String.valueOf(catsList[i].get('DataCategoryName')));
                }
            }
            am.categories = cats;
            articles.add(am);
        }     
        Map<String,Map<String,Map<String,List<String>>>> categoryHierarchy = brCategorySevice.getCategoryHierarchy(dataCategoryName);
        Map<String, String> catNameMap = brCategorySevice.getAllCategoriesMap(dataCategoryName);
        for(String key : categoryHierarchy.keySet()) {
            brCategoriesCatalogModel ccm = new brCategoriesCatalogModel();
            ccm.id = key;
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
    
    /*public static brCategoriesCatalogModel getCatalogList(String categoryName, String articleType, String dataCategoryName) {
        List<brCategoriesCatalogModel> catCatalogList = new List<brCategoriesCatalogModel>();
        List<brArticleModel> articles = new List<brArticleModel>();
        
        List<sObject> articlesList = brCategoriesCatalogServiceSelector.getArticles(articleType); 
        List<sObject> catsList = brCategoriesCatalogServiceSelector.getArticleCategories(articleType); 
        Map<String, List<brArticleModel>> articlesCats = new Map<String, List<brArticleModel>>();    
        List<brCategoryModel.CategoryWrapper> allCats = brCategorySevice.getAllCategoriesList(dataCategoryName);
        
        List<brArticleModel> tmpCats;
        String articleId;
        String parentId;
        String dataCategory;
        brCategoriesCatalogModel ccm;
        
        for (brCategoryModel.CategoryWrapper cat : allCats) {
            if (cat.parent == categoryName) {
                ccm = new brCategoriesCatalogModel();
                ccm.id = cat.id;
                ccm.name = cat.text;
                ccm.parent = cat.parent;
                catCatalogList.add(ccm);
            }
        }
        
        for (sObject k : articlesList) {
            brArticleModel am = new brArticleModel();
            
            am.id = String.valueOf(k.get('KnowledgeArticleId'));
            am.active = false;
            
            if (k.get('Nav_Title__c') != null) {
                am.title = String.valueOf(k.get('Nav_Title__c')); 
            } else {
                am.title = String.valueOf(k.get('Title'));
            }
            
            if (k.get('Article_Sections__c') != null) {
                if(String.valueOf(k.get('Article_Sections__c')).length() > 0) {
                    List<String> anchors = String.valueOf(k.get('Article_Sections__c')).split(';');
                    String result = '<ul>';
                    for(Integer li = 0; li < anchors.size(); li++) {
                        result = result + '<li>' + '<a class=\'anchor\' href=\'#'+anchors[li].split(':')[0]+'\'>'+ anchors[li].split(':')[1] +'</a>' + '</li>'; 
                    }                               
                    result = result + '</ul>';
                    am.articleSections = result;                
                }               
            }   
            
            articleId = String.valueOf(k.get('Id'));
            for (sObject obj: catsList) {
                parentId = String.valueOf(obj.get('ParentId'));
                dataCategory = String.valueOf(obj.get('DataCategoryName'));
                if (parentId == articleId) {
                    if (articlesCats.containsKey(dataCategory)) {
                    	tmpCats = articlesCats.get(dataCategory);
                    } else {
                        tmpCats = new List<brArticleModel>();
                    }
                    tmpCats.add(am);
                    articlesCats.put(dataCategory, tmpCats);
                }
            }
            
            articles.add(am);
        }     
        
        brCategoriesCatalogModel res = new brCategoriesCatalogModel();
        
        res.categories = catCatalogList;
        
        if (articlesCats.containsKey(categoryName)) {
            res.articles = articlesCats.get(categoryName);            
        }
        
        return res;
    } */
    
}