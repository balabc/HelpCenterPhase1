public with sharing class brBlogTagsTriggerHandler {

    private static final String REGEXP = '[^a-zA-Z0-9 -]';
    private static final String REPLACEMENT = '';

    public brBlogTagsTriggerHandler() {}

    public void onBeforeInsert(brBlog_Tag__c[] newTags) {

        for (brBlog_Tag__c tag : newTags) {

            if (tag.Friendly_URL__c == null) {
                tag.Friendly_URL__c = tag.Name.trim().toLowerCase()
                .replaceAll(REGEXP, REPLACEMENT).replaceAll(' ', '-').replaceAll('([-])\\1+', '$1');       
            }

            else {
                tag.Friendly_URL__c = tag.Friendly_URL__c.trim().toLowerCase()
                .replaceAll(REGEXP, REPLACEMENT).replaceAll(' ', '-').replaceAll('([-])\\1+', '$1');
            }
        }

        List<brBlog_Tag__c> oldTags  = [SELECT Friendly_URL__c
        FROM brBlog_Tag__c WHERE Id NOT IN :newTags];

        changeFrendlyUrl(newTags, oldTags);    
    }
    
    
    public void onBeforeUpdate(brBlog_Tag__c[] oldTags,
        brBlog_Tag__c[] newTags, Map<ID, brBlog_Tag__c> oldMapTags) {

        List<Id> updatedId = new List<Id>();

        for (brBlog_Tag__c tag : newTags)
        {
            updatedId.add(tag.Id);
        }

        List<brBlog_Tag__c> oldTagsWithoutUpdated =
        [SELECT Friendly_URL__c FROM brBlog_Tag__c
        WHERE ID NOT IN :updatedId];

        for (brBlog_Tag__c tag : newTags) {

            if (tag.Friendly_URL__c == null) {
                tag.Friendly_URL__c = tag.Name.trim().toLowerCase()
                .replaceAll(REGEXP, REPLACEMENT)
                .replaceAll(' ', '-').replaceAll('([-])\\1+', '$1');  
                changeFrendlyUrl(newTags, oldTags);
                
            }

            else {
                    brBlog_Tag__c oldTag = oldMapTags.get(tag.Id);
                    String oldFriendlyUrl = oldTag.Friendly_URL__c;
                    String newFriendlyUrl = tag.Friendly_URL__c;

                    if (!oldFriendlyUrl.equals(newFriendlyUrl))
                    {
                        tag.Friendly_URL__c = tag.Friendly_URL__c.trim().toLowerCase()
                        .replaceAll(REGEXP, REPLACEMENT)
                        .replaceAll(' ', '-').replaceAll('([-])\\1+', '$1'); 
                        changeFrendlyUrl(newTags, oldTagsWithoutUpdated);
                    }
                }
            }
    }

    public void changeFrendlyUrl (List<brBlog_Tag__c> newTags,
    List<brBlog_Tag__c> oldTags) {

        Set<String> friendlyUrls = new Set<String>();

        for (brBlog_Tag__c oldAndNotChangeTag : oldTags) {
            friendlyUrls.add(oldAndNotChangeTag.Friendly_URL__c);
        }

        for (brBlog_Tag__c tag : newTags) {

           if (!friendlyUrls.contains(tag.Friendly_URL__c))
           {
                friendlyUrls.add(tag.Friendly_URL__c);
           }

           else {   
                    Integer length = tag.Friendly_URL__c.length();
                    String lastElement = tag.Friendly_URL__c.substring(length - 1);

                        if (lastElement.isNumeric()) {
                           
                            for (Integer i = 1; i < 1000000; i++) {

                                tag.Friendly_URL__c  += i;

                                if (!friendlyUrls.contains(tag.Friendly_URL__c))
                                {
                                    friendlyUrls.add(tag.Friendly_URL__c);
                                    break;
                                }

                                else {
                                        tag.Friendly_URL__c = tag.Friendly_URL__c.substring(0, length);
                                }
                            }
                        }

                        else {
                                
                              for (Integer i = 1; i < 1000000; i++) {

                                tag.Friendly_URL__c  += i;

                                if (!friendlyUrls.contains(tag.Friendly_URL__c))
                                {
                                    friendlyUrls.add(tag.Friendly_URL__c);
                                    break;
                                }

                                else {
                                        tag.Friendly_URL__c = tag.Friendly_URL__c.substring(0, length);
                                }
                            }
                        }
                }
        } 
    }

}