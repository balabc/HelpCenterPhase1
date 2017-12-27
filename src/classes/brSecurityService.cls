public with sharing class brSecurityService {
    public static void performAccessCheck(String accessType, String objectName, List<String> fieldNames) {
        Schema.DescribeSObjectResult objectDescribe;

        if(objectName == 'KnowledgeArticleVersion' || objectName == 'KnowledgeArticle' || objectName == 'kav'){
            objectDescribe = KnowledgeArticleVersion.sObjectType.getDescribe();
        } else {
            objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        }

        if(accessType == 'read'){
            if(!objectDescribe.isAccessible()){
                throw new AuraHandledException('access_error');
            }

            if(fieldNames != null){
                Map<String, SObjectField> fields = objectDescribe.fields.getMap();
                for (String fieldName: fieldNames) {
                    if(!fields.get(fieldName).getDescribe().isAccessible()){
                        throw new AuraHandledException('access_error');
                    }
                }
            }
        }
        else if(accessType == 'create'){
            if(!objectDescribe.isCreateable()){
                throw new AuraHandledException('access_error');
            }

            if(fieldNames != null){
                Map<String, SObjectField> fields = objectDescribe.fields.getMap();
                for (String fieldName: fieldNames) {
                    if(!fields.get(fieldName).getDescribe().isCreateable()){
                        throw new AuraHandledException('access_error');
                    }
                }
            }
        }
        else if(accessType == 'search'){
            if(!objectDescribe.isSearchable()){
                throw new AuraHandledException('access_error');
            }
        }
        else {
            System.debug('Unknown access type!');
            throw new AuraHandledException('access_error');
        }
    }
}