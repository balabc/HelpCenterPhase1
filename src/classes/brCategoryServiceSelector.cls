public with sharing class brCategoryServiceSelector {

    /**
     * Returns categories for category group
     *
     * {@inheritDoc}
     *
     * @param       categoryGroup     String
     * @return      category list
     * @see         List<brCategoryModel.CategoryWrapper>
     */
    public static List<brCategoryModel.CategoryWrapper> getCategories(String categoryGroup) {
        try {
            List<brCategoryModel.CategoryWrapper> categoryList = new List<brCategoryModel.CategoryWrapper>();
            List<String> objType = new List<String>();
            objType.add('KnowledgeArticleVersion');
            List<DescribeDataCategoryGroupResult> describeCategoryResult = Schema.describeDataCategoryGroups(objType);
            List<Schema.DataCategoryGroupSObjectTypePair> pairs = new list<Schema.DataCategoryGroupSObjectTypePair>();
            for (Schema.DescribeDataCategoryGroupResult s : describeCategoryResult) {
                Schema.DataCategoryGroupSObjectTypePair thisPair = new Schema.DataCategoryGroupSObjectTypePair();
                thisPair.sObject = 'KnowledgeArticleVersion';
                thisPair.dataCategoryGroupName = s.getName();
                pairs.add(thisPair);
            }
            List<Schema.DescribeDataCategoryGroupStructureResult> results = Schema.describeDataCategoryGroupStructures(pairs, false);
            for (Schema.DescribeDataCategoryGroupStructureResult r : results) {
                if (r.name == categoryGroup) {
                    for (Schema.DataCategory topcat : r.getTopCategories()) {
                        for (Schema.DataCategory ch1 : topcat.childCategories) {
                            categoryList.add(new brCategoryModel.CategoryWrapper(ch1.name, ch1.label, topcat.name));
                            for (Schema.DataCategory ch2 : ch1.childCategories) {
                                categoryList.add(new brCategoryModel.CategoryWrapper(ch2.name, ch2.label, ch1.name));
                                for (Schema.DataCategory ch3 : ch2.childCategories) {categoryList.add(new brCategoryModel.CategoryWrapper(ch3.name, ch3.label, ch2.name));}
                            }

                        }
                    }
                }
            }
            return categoryList;
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns first level categories for category group
     *
     * {@inheritDoc}
     *
     * @param       categoryGroup     String
     * @return      category list
     * @see         List<brCategoryModel.CategoryWrapper>
     */
    public static List<brCategoryModel.CategoryWrapper> getFirstCategories(String categoryGroup) {
        try {
            List<brCategoryModel.CategoryWrapper> categoryList = new List<brCategoryModel.CategoryWrapper>();
            List<String> objType = new List<String>();
            objType.add('KnowledgeArticleVersion');
            List<DescribeDataCategoryGroupResult> describeCategoryResult = Schema.describeDataCategoryGroups(objType);
            List<Schema.DataCategoryGroupSObjectTypePair> pairs = new list<Schema.DataCategoryGroupSObjectTypePair>();

            Schema.DataCategoryGroupSObjectTypePair thisPair = new Schema.DataCategoryGroupSObjectTypePair();
            thisPair.sObject = 'KnowledgeArticleVersion';
            thisPair.dataCategoryGroupName = categoryGroup;
            pairs.add(thisPair);
            List<Schema.DescribeDataCategoryGroupStructureResult> results = Schema.describeDataCategoryGroupStructures(pairs,false);
            for(Schema.DescribeDataCategoryGroupStructureResult r : results) {
                if(r.name == categoryGroup) {
                    for( Schema.DataCategory topcat: r.getTopCategories()) {
                        for(Schema.DataCategory ch1 :topcat.childCategories) { categoryList.add(new brCategoryModel.CategoryWrapper(ch1.name,ch1.label,topcat.name));}
                    }
                }
            }
            return categoryList;
        } catch (Exception e) {System.debug(e);return null;}
    }

    /**
     * Returns subcategories for category
     *
     * {@inheritDoc}
     *
     * @param       category     String
     * @return      category list
     * @see         List<brCategoryModel.CategoryWrapper>
     */
    public static List<brCategoryModel.CategoryWrapper> getSubCategories(String category){
        try {
            List<brCategoryModel.CategoryWrapper> categoryList = new List<brCategoryModel.CategoryWrapper>();
            List<String> objType = new List<String>();
            objType.add('KnowledgeArticleVersion');
            List<DescribeDataCategoryGroupResult> describeCategoryResult = Schema.describeDataCategoryGroups(objType);
            List<Schema.DataCategoryGroupSObjectTypePair> pairs = new list<Schema.DataCategoryGroupSObjectTypePair>();
            for(Schema.DescribeDataCategoryGroupResult s : describeCategoryResult) {
                Schema.DataCategoryGroupSObjectTypePair thisPair = new Schema.DataCategoryGroupSObjectTypePair();
                thisPair.sObject = 'KnowledgeArticleVersion';
                thisPair.dataCategoryGroupName = s.getName();
                pairs.add(thisPair);
            }

            List<Schema.DescribeDataCategoryGroupStructureResult> results = Schema.describeDataCategoryGroupStructures(pairs,false);
            for(Schema.DescribeDataCategoryGroupStructureResult r : results) {
                for( Schema.DataCategory topcat: r.getTopCategories()) {
                    for(Schema.DataCategory ch1 :topcat.childCategories) {
                        for(Schema.DataCategory ch2 :ch1.childCategories){
                            if(ch1.name == category) {categoryList.add(new brCategoryModel.CategoryWrapper(ch2.name,ch2.label,ch1.name));
                            } else {
                                for(Schema.DataCategory ch3 :ch2.childCategories){
                                    if(ch2.name == category) {categoryList.add(new brCategoryModel.CategoryWrapper(ch3.name,ch3.label,ch2.name));}
                                }
                            }
                        }
                    }
                }
            }
            return categoryList;
        } catch (Exception e) {System.debug(e);return null;}
    }

}