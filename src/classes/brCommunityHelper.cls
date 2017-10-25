public without sharing class brCommunityHelper {

    public static Network getNetworkById(String ntwrkId){
        return [SELECT Name, OptionsNicknameDisplayEnabled FROM Network WHERE Id = :ntwrkId];
    }

    public static User getUserById(String usrId){
        return [SELECT CommunityNickname, FirstName, LastName FROM User WHERE Id = :usrId];
    }

}