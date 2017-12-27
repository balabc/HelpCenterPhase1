public with sharing class brCategoryService {

    /**
     * Returns all categories for category group
     *
     * {@inheritDoc}
     *
     * @param       categoryGroup     String
     * @return      categories as Map
     * @see         Map<String,String>
     */
    public static Map<String,String> getAllCategoriesMap(String categoryGroup) {
        brSecurityService.performAccessCheck('read', 'KnowledgeArticleVersion', new List<String>{'Id'});

        Map<String,String> result = new Map<String,String>();
        for(brCategoryModel.CategoryWrapper cat : brCategoryServiceSelector.getCategories(categoryGroup)) {
            result.put(cat.id, cat.text);
        }
        return result;
    }

    /**
     * Returns hierarchy categories for category group
     *
     * {@inheritDoc}
     *
     * @param       categoryGroup     String
     * @return      hierarchy categories
     * @see         Map<String,Map<String,Map<String,List<String>>>>
     */
    public static Map<String,Map<String,Map<String,List<String>>>> getCategoryHierarchy(String categoryGroup){
        brSecurityService.performAccessCheck('read', 'KnowledgeArticleVersion', new List<String>{'Id'});

        Map<String,Map<String,Map<String,List<String>>>> subCategoriesMap = new Map<String,Map<String,Map<String,List<String>>>>();
        for(brCategoryModel.CategoryWrapper cat: brCategoryServiceSelector.getFirstCategories(categoryGroup) ) {
            Map<String,Map<String,List<String>>> subsubCategoriesMap = new Map<String,Map<String,List<String>>>();
            
            for(brCategoryModel.CategoryWrapper subCat : brCategoryServiceSelector.getSubCategories(cat.id)) {
                Map<String,List<String>> subsubsubCategoriesMap = new Map<String,List<String>>();
                for(brCategoryModel.CategoryWrapper subsubCat : brCategoryServiceSelector.getSubCategories(subCat.id)) {
                    subsubsubCategoriesMap.put(subsubCat.id, new List<String>());
                }
                subsubCategoriesMap.put(subCat.id, subsubsubCategoriesMap);
            }          
            subCategoriesMap.put(cat.id,subsubCategoriesMap );
        }
        return subCategoriesMap ;
    }

}