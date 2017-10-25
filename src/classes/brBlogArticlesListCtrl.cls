public with sharing class brBlogArticlesListCtrl {

    private static final Integer DEFAULT_ITEMS_PER_PAGE = 5;
    private static final Integer MAX_ITEMS_PER_PAGE = 500;

    @AuraEnabled
    public static List<brBlogArticleWrapper> getArticles(Map<String,String> filterData, Integer page, Integer itemsPerPage) {
        List<brBlogArticleWrapper> articlesWrapped = new List<brBlogArticleWrapper>();
        String currentTimeGMT = DateTime.now().formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_article__c', new List<String>{'Short_Body__c', 'Published_Date__c', 'Draft__c'})
                || !brBlogHelper.performAccessCheck('read', 'brBlog_Category__c', new List<String>{'Friendly_URL__c'})
                || !brBlogHelper.performAccessCheck('read', 'brBlog_Tag__c', new List<String>{'Friendly_URL__c'})
                || !brBlogHelper.performAccessCheck('read', 'brCategory_Assignment__c', null)
                || !brBlogHelper.performAccessCheck('read', 'brBlog_Tag_Assignment__c', null)){
            return articlesWrapped;
        }

        String queryFields = 'Id, Name, Owner.Name, OwnerId, Published_Date__c, ' +
                'Short_Body__c, (SELECT Id, Blog_Category__r.Name, Blog_Category__r.Friendly_URL__c ' +
                'FROM Category_Assignment__r ORDER BY Blog_Category__r.Name), ' +
                ' (SELECT Id, Blog_Tag__r.Name, Blog_Tag__r.Friendly_URL__c' +
                ' FROM Blog_Tag_Assignment__r ORDER BY Blog_Tag__r.Name)';
        String query = 'SELECT ' + queryFields + ' FROM brBlog_article__c'
                + ' WHERE Draft__c = false AND Published_Date__c < ' + currentTimeGMT;
        String queryWhere = brBlogHelper.compileWhereStatement(filterData);

        page = Integer.valueOf(page);
        itemsPerPage = Integer.valueOf(itemsPerPage);

        if (itemsPerPage < 1 || itemsPerPage > MAX_ITEMS_PER_PAGE) itemsPerPage = DEFAULT_ITEMS_PER_PAGE;

        query += String.isNotBlank(queryWhere) ? ' AND ' + queryWhere : '';
        //query += (UserInfo.getUserType() == 'Guest') ? ' AND Publicly_available__c = true' : '';
        query += ' ORDER BY Published_Date__c DESC';
        query += ' LIMIT ' + itemsPerPage;
        query += (page > 1) ? ' OFFSET ' + String.valueOf(itemsPerPage * (page - 1)) : '';

        System.debug(query);

        List<brBlog_article__c> articles = Database.query(query);

        if (articles.size() < 1) {
            return articlesWrapped;
        }

        Set<Id> userIds = new Set<Id>();

        for (brBlog_article__c article : articles) {
            userIds.add(article.OwnerId);
        }

        Map<Id,String> photoUrlByUser = brBlogHelper.getProfilePhotoUrl(userIds);

        for (brBlog_article__c article: articles) {
            brBlogArticleWrapper aw = new brBlogArticleWrapper();
            aw.item = article;
            aw.profilePhotoUrl = photoUrlByUser.get(article.OwnerId);
            aw.categories = brBlogHelper.getArticleCategories(article.Category_Assignment__r);
            aw.tags = brBlogHelper.getArticleTags(article.Blog_Tag_Assignment__r);
            aw.commentsNumber = brBlogHelper.getCommentsNumber(article.Id);
            articlesWrapped.add(aw);
        }

        return articlesWrapped;
    }

    @AuraEnabled
    public static Integer getArticlesCount(Map<String,String> filterData) {
        Integer articlesCount = 0;

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_article__c', new List<String>{'Published_Date__c', 'Draft__c'})){
            return articlesCount;
        }

        String currentTimeGMT = DateTime.now().formatGmt('YYYY-MM-dd\'T\'HH:mm:ss\'Z\'');

        String query = 'SELECT COUNT() FROM brBlog_article__c'
                +' WHERE Draft__c = false AND Published_Date__c < ' + currentTimeGMT;
        String queryWhere = brBlogHelper.compileWhereStatement(filterData);

        query += String.isNotBlank(queryWhere) ? ' AND ' + queryWhere : '';

        articlesCount = Database.countQuery(query);

        return articlesCount;
    }
}