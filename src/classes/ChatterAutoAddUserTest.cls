@isTest
private class ChatterAutoAddUserTest {
    
    static testmethod void addUser() {
    
        //Create the new CollaborationGroup.
        List<CollaborationGroupMember> recTestGroup = new List<CollaborationGroupMember>();
        List<CollaborationGroupMember> knowTestGroup = new List<CollaborationGroupMember>();
        List<CollaborationGroupMember> servTestGroup = new List<CollaborationGroupMember>();
        List<CollaborationGroupMember> markTestGroup = new List<CollaborationGroupMember>(); 
        
        //Grab the profile Ids we need.
        Id recProfileId = [SELECT Id FROM Profile WHERE Name = 'ASU Recruiting User' LIMIT 1].Id;
        Id knowProfileId = [SELECT Id FROM Profile WHERE Name = 'ASU Knowledge User' LIMIT 1].Id;
        Id servProfileId = [SELECT Id FROM Profile WHERE Name LIKE 'ASU Service%' LIMIT 1].Id;
        Id markProfileId = [SELECT Id FROM Profile WHERE Name = 'ASU Marketing User' LIMIT 1].Id;
        
        //Create the test user.
        User testUser = new User();
        testUser.FirstName = 'Chatter';
        testUser.LastName = 'Testuser';
        //testUser.ProfileId = '00ed00000019yGsAAI';
        testUser.ProfileId = recProfileId;
        testUser.Username = 'chattestuser@test.com.dev';
        testUser.Email = 'chattestuser@test.com';
        testUser.Alias = 'chattes3';
        testUser.CommunityNickname = 'chattest';
        testUser.TimeZoneSidKey = 'America/Phoenix';
        testUser.LocaleSidKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.LanguageLocaleKey = 'en_US';
        insert testUser;
        
        system.debug('User Created');
        
        List<CollaborationGroup> recG = [SELECT Id FROM CollaborationGroup WHERE Name = 'ASU Recruitment'];
        List<CollaborationGroup> servG = [SELECT Id FROM CollaborationGroup WHERE Name = 'ASU Service'];
        List<CollaborationGroup> knowG = [SELECT Id FROM CollaborationGroup WHERE Name = 'Knowledge Users'];
        
        
        Test.startTest();
        
        //Try and add user to Recruiting group.
        try {
            recTestGroup.add(new CollaborationGroupMember (CollaborationGroupId = recG[0].Id, MemberId = testUser.Id));
            system.debug('User added to group');
        } catch(Exception e) {
            system.debug(e);
        }
        
        //Try and add user to Knowledge group.
        try {
            knowTestGroup.add(new CollaborationGroupMember (CollaborationGroupId = knowG[0].Id, MemberId = testUser.Id));
            system.debug('User added to group');
        } catch(Exception e) {
            system.debug(e);
        }
        
        //Try and add user to Service group.
        try {
            servTestGroup.add(new CollaborationGroupMember (CollaborationGroupId = servG[0].Id, MemberId = testUser.Id));
            system.debug('User added to group');
        } catch(Exception e) {
            system.debug(e);
        }
        
        //Try and add user to Marketing group.
        try {
            markTestGroup.add(new CollaborationGroupMember (CollaborationGroupId = recG[0].Id, MemberId = testUser.Id));
            system.debug('User added to group');
        } catch(Exception e) {
            system.debug(e);
        }
        
        Test.stopTest();
    }
}