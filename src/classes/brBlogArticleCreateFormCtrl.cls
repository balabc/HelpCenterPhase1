public with sharing class brBlogArticleCreateFormCtrl {

    @AuraEnabled
    public static List<brBlog_Category__c> getCategories() {
        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_Category__c', null))
           return null;

        return [SELECT Id, Name FROM brBlog_Category__c ORDER BY Name ASC LIMIT 150];
    }

    @AuraEnabled
    public static Boolean getAllowCreateArticle() {
        return brBlogHelper.getAllowCreateArticle();
    }

    @AuraEnabled
    public static String saveArticle(Map<String,String> articleFields, String tags, String categories) {

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_Settings__c', new List<String>{'Value__c'})
                || !brBlogHelper.performAccessCheck('read', 'brBlog_article__c', new List<String>{'Short_Body__c', 'Body__c'})
                || !brBlogHelper.performAccessCheck('create', 'brBlog_article__c', new List<String>{'Draft__c'})
                || !brBlogHelper.performAccessCheck('create', 'brBlog_Tag_Assignment__c', new List<String>{'Blog_Article__c', 'Blog_Tag__c'})
                || !brBlogHelper.performAccessCheck('create', 'brCategory_assignment__c', new List<String>{'Blog_Article__c', 'Blog_Category__c'})){
            return null;
        }

        Boolean allowCreateArticle = brBlogHelper.getAllowCreateArticle();
        brBlog_article__c article = new brBlog_article__c();

        if (allowCreateArticle == true) {

            List<brBlog_Tag__c> inputTags = new List<brBlog_Tag__c>();
            String moderation = brBlog_Settings__c.getValues(brBlogHelper.MODERATION_SETTING).Value__c;

            article.Name = articleFields.get('name');
            article.Short_Body__c = articleFields.get('shortBody');
            article.Body__c = articleFields.get('body');

            if ( (article.Name != '') && (article.Short_Body__c != '')
                    && (article.Body__c != '') && (categories != '') ) {

                if ((moderation == 'all') || ( (UserInfo.getUserType() != 'Standard') && (moderation == 'external') ) ) {
                    article.Draft__c = true;
                }

                try {
                    insert article;
                }
                catch(DmlException e) {
                    System.debug(e.getMessage());
                    return null;
                }
            }

            if (tags != null) {
                inputTags = getTags(tags);
            }

            if (!inputTags.isEmpty()) {
                brBlogHelper.insertAttachmentTags(article.Id, inputTags);
            }

            Set<brBlog_Category__c> selectCategories = getCategories(categories);

            if (!selectCategories.isEmpty()) {
                brBlogHelper.insertAttachmentCategories(article.Id, selectCategories);
            }

            if ((moderation == 'all') || ( (UserInfo.getUserType() != 'Standard') && (moderation == 'external') ) ) {
                brBlogHelper.sendMails(article.Id, UserInfo.getFirstName(), UserInfo.getLastName());
            }
        }
        return article.Id;
    }

    public static List<brBlog_Tag__c> getTags(String tagsName) {

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_Tag__c', null)
                || !brBlogHelper.performAccessCheck('create', 'brBlog_Tag__c', null)){
            return null;
        }

        List<String> inputTagsName = tagsName.split(',');

        List<String> inputTagsNameFormatted = new List<String>();

        for (String inputTagName : inputTagsName) {
            inputTagsNameFormatted.add(inputTagName.trim());
        }

        List<brBlog_Tag__c> tags = [SELECT Id, Name FROM brBlog_Tag__c
        WHERE (Name IN :inputTagsNameFormatted) OR  (Name NOT IN :inputTagsNameFormatted)];
        Set<String> oldTags = new Set<String>();

        for (brBlog_Tag__c tag : tags) {
            oldTags.add(tag.Name.toUpperCase());
        }

        List<brBlog_Tag__c> newTags = new List<brBlog_Tag__c>();

        for (String inputTagName : inputTagsNameFormatted) {

            if (!oldTags.contains(inputTagName.trim().toUpperCase())) {
                newTags.add(new brBlog_Tag__c(Name = inputTagName.trim()));
            }
        }

        if (!newTags.isEmpty()) {
            try {
                insert newTags;
            }
            catch(DmlException e) {
                System.debug(e.getMessage());
            }
        }

        List<brBlog_Tag__c> selectedTags = [SELECT Id, Name FROM brBlog_Tag__c WHERE Name IN :inputTagsNameFormatted];

        return selectedTags;
    }

    public static Set<brBlog_Category__c> getCategories(String categories) {

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_Category__c', null)){
            return null;
        }

        List<String> newCategoriesName = categories.split(';');


        List<brBlog_Category__c> newCategories = [SELECT Id, Name FROM brBlog_Category__c
        WHERE Name IN :newCategoriesName];

        Set<brBlog_Category__c> selectUniqueCategories = new Set<brBlog_Category__c>();

        for (brBlog_Category__c category : newCategories) {

            selectUniqueCategories.add(category);
        }

        return selectUniqueCategories;
    }

}