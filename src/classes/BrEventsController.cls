public with sharing class BrEventsController {

    @AuraEnabled
    public static Map<String, String> getUserInfo(){
        Map<String, String> uInf = new Map<String, String>();
        uInf.put('Id', UserInfo.getUserId());
        uInf.put('Name', UserInfo.getName());
        uInf.put('Username', UserInfo.getUserName());
        uInf.put('Email', UserInfo.getUserEmail());
        uInf.put('Type', UserInfo.getUserType());

        return uInf;
    }
}