public with sharing class brBlogCategoryTriggerHandler {

    private static final String REGEXP = '[^a-zA-Z0-9 -]';
    private static final String REPLACEMENT = '';

    public brBlogCategoryTriggerHandler() {}
         
    public void onBeforeInsert(brBlog_Category__c[] newCategories) {

        for (brBlog_Category__c category : newCategories) {

            if (category.Friendly_URL__c == null) {
                category.Friendly_URL__c = category.Name.trim().toLowerCase()
                .replaceAll(REGEXP, REPLACEMENT).replaceAll(' ', '-').replaceAll('([-])\\1+', '$1');       
            }

            else {
                category.Friendly_URL__c = category.Friendly_URL__c.trim().toLowerCase()
                .replaceAll(REGEXP, REPLACEMENT).replaceAll(' ', '-').replaceAll('([-])\\1+', '$1');
            }
        }

        List<brBlog_Category__c> oldCategories  = [SELECT Friendly_URL__c
        FROM brBlog_Category__c  WHERE Id NOT IN :newCategories];

        changeFrendlyUrl(newCategories, oldCategories);    
    }
    
    
    public void onBeforeUpdate(brBlog_Category__c[] oldCategories,
        brBlog_Category__c[] newCategories, Map<ID, brBlog_Category__c> oldMapCategory) {

        List<Id> updatedId = new List<Id>();

        for (brBlog_Category__c category : newCategories)
        {
            updatedId.add(category.Id);
        }

        List<brBlog_Category__c> oldCategoriesWithoutUpdated =
        [SELECT Friendly_URL__c FROM brBlog_Category__c
        WHERE ID NOT IN :updatedId];

        for (brBlog_Category__c category : newCategories) {

            if (category.Friendly_URL__c == null) {
                category.Friendly_URL__c = category.Name.trim().toLowerCase()
                .replaceAll(REGEXP, REPLACEMENT)
                .replaceAll(' ', '-').replaceAll('([-])\\1+', '$1');  
                changeFrendlyUrl(newCategories, oldCategories);
                
            }

            else {
                    brBlog_Category__c oldCategory = oldMapCategory.get(category.Id);
                    String oldFriendlyUrl = oldCategory.Friendly_URL__c;
                    String newFriendlyUrl = category.Friendly_URL__c;

                    if (!oldFriendlyUrl.equals(newFriendlyUrl))
                    {
                        category.Friendly_URL__c = category.Friendly_URL__c.trim().toLowerCase()
                        .replaceAll(REGEXP, REPLACEMENT)
                        .replaceAll(' ', '-').replaceAll('([-])\\1+', '$1'); 
                        changeFrendlyUrl(newCategories, oldCategoriesWithoutUpdated);
                    }
                }
            }
        }

    public void changeFrendlyUrl (List<brBlog_Category__c> newCategories,
    List<brBlog_Category__c> oldCategories) {

        Set<String> friendlyUrls = new Set<String>();

        for (brBlog_Category__c oldAndNotChangeCategory : oldCategories) {
            friendlyUrls.add(oldAndNotChangeCategory.Friendly_URL__c);
        }

        for (brBlog_Category__c category : newCategories) {

           if (!friendlyUrls.contains(category.Friendly_URL__c))
           {
                friendlyUrls.add(category.Friendly_URL__c);
           }

           else {   
                    Integer length = category.Friendly_URL__c.length();
                    String lastElement = category.Friendly_URL__c.substring(length - 1);

                        if (lastElement.isNumeric()) {
                           
                           for (Integer i = 1; i < 1000000; i++) {

                                category.Friendly_URL__c  += i;

                                if (!friendlyUrls.contains(category.Friendly_URL__c))
                                {
                                    friendlyUrls.add(category.Friendly_URL__c);
                                    break;
                                }

                                else {
                                        category.Friendly_URL__c = category.Friendly_URL__c.substring(0, length);
                                }
                            }
                        }

                        else {
                                
                              for (Integer i = 1; i < 1000000; i++) {

                                category.Friendly_URL__c  += i;

                                if (!friendlyUrls.contains(category.Friendly_URL__c))
                                {
                                    friendlyUrls.add(category.Friendly_URL__c);
                                    break;
                                }

                                else {
                                        category.Friendly_URL__c = category.Friendly_URL__c.substring(0, length);
                                }
                            }
                        }
                }
        } 
    }
}

