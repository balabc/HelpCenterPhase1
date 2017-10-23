public with sharing class brBlogArticleDetailCtrl {

    @AuraEnabled
    public static brBlogArticleWrapper getArticle(Id articleId) {
        brBlogArticleWrapper articleWrapped = new brBlogArticleWrapper();

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_article__c', new List<String>{'Body__c', 'Published_Date__c', 'Draft__c'})
                || !brBlogHelper.performAccessCheck('read', 'brBlog_Category__c', new List<String>{'Friendly_URL__c'})
                || !brBlogHelper.performAccessCheck('read', 'brBlog_Tag__c', new List<String>{'Friendly_URL__c'})
                || !brBlogHelper.performAccessCheck('read', 'brCategory_Assignment__c', null)
                || !brBlogHelper.performAccessCheck('read', 'brBlog_Tag_Assignment__c', null)){
            return articleWrapped;
        }

        List<brBlog_article__c> articles = [SELECT Id, Name, Owner.Id, OwnerId, Owner.Name, Body__c, Published_Date__c, Draft__c,
                                                        (SELECT Id, Blog_Category__r.Name, Blog_Category__r.Friendly_URL__c
                                                        FROM Category_Assignment__r),
                                                        (SELECT Id, Blog_Tag__r.Name, Blog_Tag__r.Friendly_URL__c
                                                        FROM Blog_Tag_Assignment__r)
                                                    FROM brBlog_article__c
                                                    WHERE Id = :articleId];

        if (articles.size() < 1) {
            return articleWrapped;
        }

        Set<Id> userId = new Set<Id>();
        userId.add(articles.get(0).OwnerId);

        articleWrapped.item = articles.get(0);
        articleWrapped.categories = brBlogHelper.getArticleCategories(articles.get(0).Category_Assignment__r);
        articleWrapped.tags = brBlogHelper.getArticleTags(articles.get(0).Blog_Tag_Assignment__r);
        articleWrapped.commentsNumber = brBlogHelper.getCommentsNumber(articleId);
        articleWrapped.profilePhotoUrl = brBlogHelper.getProfilePhotoUrl(userId).get(articles.get(0).OwnerId);

        return articleWrapped;
    }
}