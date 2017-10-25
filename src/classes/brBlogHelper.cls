public with sharing class brBlogHelper {

    public static final String MODERATION_SETTING ='Moderation';
    public static final String ALLOW_MEMBERS_ADD_ARTICLES_SETTING = 'AllowMembersAddArticles';
    public static final String MODERATOR_EMAIL_ADDRESSES_SETTING = 'ModeratorEmailAddresses';
    public static final String BLOG_AUTHOR_PERMISSION_SET = 'AC_Blog_Author';
    public static final String BLOG_MODERATION_EMAIL_TEMPLATE = 'Blog Moderation';

    public static void insertAttachmentTags(Id articleId, List<brBlog_Tag__c> inputTags) {
        List<brBlog_Tag_Assignment__c> tagsAssignment = new List<brBlog_Tag_Assignment__c>();

        for (brBlog_Tag__c tag : inputTags) {
            tagsAssignment.add(new brBlog_Tag_Assignment__c(Blog_Article__c = articleId,
                    Blog_Tag__c = tag.Id));
        }

        try {
            insert tagsAssignment;
        }
        catch(DmlException e) {
            System.debug(e.getMessage());
        }
    }

    public static void insertAttachmentCategories(Id articleId, Set<brBlog_Category__c> selectCategories) {
        List<brCategory_assignment__c> categoriesAssignment = new List<brCategory_assignment__c>();

        for (brBlog_Category__c category : selectCategories) {
            categoriesAssignment.add(new brCategory_assignment__c(Blog_Article__c = articleId,
                    Blog_Category__c = category.Id));
        }

        try {
            insert categoriesAssignment;
        }
        catch(DmlException e) {
            System.debug(e.getMessage());
        }
    }

    public static List<brBlog_Category__c> getArticleCategories(List<brCategory_assignment__c> categoryAssignments) {
        List<brBlog_Category__c> articleCategories = new List<brBlog_Category__c>();

        for(brCategory_assignment__c cat: categoryAssignments){
            articleCategories.add(cat.Blog_Category__r);
        }

        return articleCategories;
    }

    public static List<brBlog_Tag__c> getArticleTags(List<brBlog_Tag_Assignment__c> tagAssignments) {
        List<brBlog_Tag__c> articleTags = new List<brBlog_Tag__c>();

        for(brBlog_Tag_Assignment__c tag: tagAssignments){
            articleTags.add(tag.Blog_Tag__r);
        }

        return articleTags;
    }

    public static Boolean getAllowCreateArticle() {
        Boolean isAllowUserType = false;

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_Settings__c', new List<String>{'Value__c'})){
            return false;
        }

        if (UserInfo.getUserType() == 'Guest') {
            isAllowUserType = false;
        }

        else {
            String allowCustomer = brBlog_Settings__c.getValues(ALLOW_MEMBERS_ADD_ARTICLES_SETTING).Value__c;

            if (allowCustomer == 'true') {
                isAllowUserType = true;
            }

            else {
                List<PermissionSetAssignment> assignments = [SELECT PermissionSet.Name
                FROM PermissionSetAssignment
                WHERE Assignee.Id = :UserInfo.getUserId()
                AND PermissionSet.Name = :BLOG_AUTHOR_PERMISSION_SET];
                if (!assignments.isEmpty()) {
                    isAllowUserType = true;
                }

                else {
                    isAllowUserType = false;
                }
            }
        }
        return isAllowUserType;
    }

    public static void sendMails(Id articleId, String firstName, String lastName){

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'EmailTemplate', null)){
            return;
        }

        EmailTemplate emailTemplate = [SELECT Subject, Body FROM EmailTemplate WHERE Name = :BLOG_MODERATION_EMAIL_TEMPLATE];

        String body = emailTemplate.Body;
        body = body.replace('{!User.FirstName}', firstName);
        body = body.replace('{!User.LastName}', lastName);
        String instanceUrl= System.URL.getSalesforceBaseUrl().toExternalForm();
        body = body.replace('{!Blog_article__c.Link}', instanceUrl + '/' + articleId);

        String moderatorAddresses = brBlog_Settings__c.getValues(MODERATOR_EMAIL_ADDRESSES_SETTING).Value__c;

        List<String> addresses = moderatorAddresses.split(',');

        List<String> addressesFormatted = new  List<String>();

        for (String address : addresses) {
            addressesFormatted.add(address.trim());
        }

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.toAddresses = addressesFormatted;
        email.setSenderDisplayName('AC Blog');
        email.setSubject(emailTemplate.Subject);
        email.setPlainTextBody(body);

        try {
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
        }
        catch(EmailException ex) {
            System.debug(ex.getMessage());
        }
    }

    public static Integer getCommentsNumber(Id articleId) {
        Integer commentsNumber = 0;

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_article__Feed', null)){
            return commentsNumber;
        }

        List<brBlog_article__Feed> fList = [SELECT CommentCount FROM brBlog_article__Feed WHERE ParentId = :articleId];

        if(fList.size() > 0) {
            for (brBlog_article__Feed fi: fList) {
                commentsNumber += fi.CommentCount;
            }
            commentsNumber += fList.size();
        }

        return commentsNumber;
    }

    public static String compileWhereStatement(Map<String,String> filterData) {
        String whereString = '';
        List<String> whereList = new List<String>();
        List<String> searchIds = new List<String>();

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'brBlog_Category__c', new List<String>{'Friendly_URL__c'})
                || !brBlogHelper.performAccessCheck('read', 'brBlog_Tag__c', new List<String>{'Friendly_URL__c'})
                || !brBlogHelper.performAccessCheck('read', 'brBlog_Tag_Assignment__c', new List<String>{'Blog_Article__c'})
                || !brBlogHelper.performAccessCheck('read', 'brCategory_Assignment__c', new List<String>{'Blog_Article__c'})){
            return whereString;
        }

        if (filterData == null) return whereString;

        String category = filterData.get('category');
        String tag = filterData.get('tag');

        if(String.isNotBlank(category)){
            for(brCategory_Assignment__c ca: [SELECT Blog_Article__c
            FROM brCategory_Assignment__c
            WHERE Blog_Category__r.Friendly_URL__c = :category]) {
                searchIds.add(ca.Blog_Article__c);
            }
            whereList.add('Id IN (\'' + String.join(searchIds, '\',\'') + '\')');
        }
        else if(String.isNotBlank(tag)) {
            for(brBlog_Tag_Assignment__c bta: [SELECT Blog_Article__c
            FROM brBlog_Tag_Assignment__c
            WHERE Blog_Tag__r.Friendly_URL__c = :tag]) {
                searchIds.add(bta.Blog_Article__c);
            }
            whereList.add('Id IN (\'' + String.join(searchIds, '\',\'') + '\')');
        }

        if(whereList.size() > 0){
            whereString = String.join(whereList, ' AND ');
        }

        return whereString;
    }

    public static Map<Id, String> getProfilePhotoUrl(Set<Id> userIds) {

        Map<Id, String> photoUrlByUser = new Map<Id, String>();

        // CRUD/FLS enforcement check
        if(!brBlogHelper.performAccessCheck('read', 'User', null)){
            return photoUrlByUser;
        }

        for (User user : [SELECT Id, SmallPhotoUrl  FROM User WHERE Id IN :userIds]) {
            photoUrlByUser.put(user.Id, user.SmallPhotoUrl);
        }

        return photoUrlByUser;
    }

    public static Boolean performAccessCheck(String accessType, String objectName, List<String> fieldNames) {
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();

        if(accessType == 'read'){
            if(!objectDescribe.isAccessible()){
                return false;
            }

            if(fieldNames != null){
                Map<String, SObjectField> fields = objectDescribe.fields.getMap();
                for (String fieldName: fieldNames) {
                    if(!fields.get(fieldName).getDescribe().isAccessible()){
                        return false;
                    }
                }
            }
            return true;
        }
        else if(accessType == 'create'){
            if(!objectDescribe.isCreateable()){
                return false;
            }

            if(fieldNames != null){
                Map<String, SObjectField> fields = objectDescribe.fields.getMap();
                for (String fieldName: fieldNames) {
                    if(!fields.get(fieldName).getDescribe().isCreateable()){
                        return false;
                    }
                }
            }
            return true;
        }
        else if(accessType == 'edit'){
            if(!objectDescribe.isUpdateable()){
                return false;
            }

            if(fieldNames != null){
                Map<String, SObjectField> fields = objectDescribe.fields.getMap();
                for (String fieldName: fieldNames) {
                    if(!fields.get(fieldName).getDescribe().isUpdateable()){
                        return false;
                    }
                }
            }
            return true;
        }
        else {
            return false;
        }
    }

}