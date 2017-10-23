public with sharing class brCategoriesCatalogService {
    public static List<brCategoriesCatalogModel> getCatalog(String selectId) {
        List<brCategoriesCatalogModel> catCatalogList = new List<brCategoriesCatalogModel>();
        List<Knowledge__kav> dailyUpdatesList = brCategoriesCatalogServiceSelector.getArticles();   
        List<brArticleModel> articles = new List<brArticleModel>();
        for(Knowledge__kav k : dailyUpdatesList) {
            brArticleModel am = new brArticleModel();
            if(k.Nav_Title__c != null) {
                am.title = k.Nav_Title__c; 
            } else {
                am.title = k.Title;
            }
            if(selectId == k.KnowledgeArticleId) {
                am.active = true;
            } else {
                am.active = false;
            }
            am.articleSections = k.Article_Sections__c;
            am.id = k.KnowledgeArticleId;
            Set<String> cats = new Set<String>();
            for(Knowledge__DataCategorySelection dc : k.DataCategorySelections) {
                cats.add(dc.DataCategoryName);
            }        
            am.categories = cats;
            articles.add(am);
        }     
        
        Map<String,Map<String,Map<String,List<String>>>> categoryHierarchy = brCategorySevice.getCategoryHierarchy('All');
        Map<String, String> catNameMap = brCategorySevice.getAllCategoriesMap('All');
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
        return catCatalogList ;
    } 
}