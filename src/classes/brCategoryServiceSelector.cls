public with sharing class brCategoryServiceSelector {

    public static List<brCategoriesCatalogModel> getChildCategories(DataCategory rootCategory, String groupName) {
        List<brCategoriesCatalogModel> items = new List<brCategoriesCatalogModel>();
        brCategoriesCatalogModel item;

        DataCategory[] children = rootCategory.getChildCategories();

        for (DataCategory ch : children) {
            String categoryId = ch.getName();
            item = new brCategoriesCatalogModel();
            item.id = categoryId;
            item.name = ch.getLabel();
            item.categories = getChildCategories(ch, groupName);

            items.add(item);
        }

        return items;
    }

    public static List<DataCategoryGroupSobjectTypePair> getDataCategoryGroupPairs(String categoryGroup) {

        List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
        List<String> objType = new List<String>();
        objType.add('KnowledgeArticleVersion');

        List<DescribeDataCategoryGroupResult> categoryGroups = Schema.describeDataCategoryGroups(objType);

        for (DescribeDataCategoryGroupResult group_res: categoryGroups) {
            DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
            p.setSobject('KnowledgeArticleVersion');

            if (categoryGroup != null && !Test.isRunningTest()) {
                p.setDataCategoryGroupName(categoryGroup);
                pairs.add(p);
                break;
            } else {
                p.setDataCategoryGroupName(group_res.getName());
                pairs.add(p);
            }
        }
        return pairs;

    }

}