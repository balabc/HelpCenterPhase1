public with sharing class LiveAgentChatButton {

    @AuraEnabled
    public static Contact getContact(Id contactId) {
        Contact c = null;
        try {
            User usr = [SELECT ContactId
            FROM User
            WHERE Id = :UserInfo.getUserId()];
            if (usr.ContactId != null) {
                c = [ SELECT Id, Name, Email, Phone FROM Contact WHERE Id = :usr.ContactId ];
            } else {
                c = new Contact(FirstName = 'she');
            }
        }catch (Exception e){
            System.debug('LiveAgentChatButton getContact Error: ' + e.getMessage());
        }
        return c;
    }

}