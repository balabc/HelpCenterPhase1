@IsTest
public class brTestDataFactory {
    public static User createTestStandardProfileUser() {
        Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(Alias = 'test', Email = 'standard@test.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Baker', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = stdUserProfile.Id, UserPermissionsKnowledgeUser = true,
                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'sysUserBaker@test.com');

        insert testUser;

        assignPermissionSet(testUser.Id, 'Community_Customer');

        System.assertEquals('sysUserBaker@test.com', testUser.UserName, 'wrong username');

        return testUser;
    }

    @future
    static private void assignPermissionSet(Id userId, String permissionSetName) {
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName];

        insert new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = ps.Id);
    }
}