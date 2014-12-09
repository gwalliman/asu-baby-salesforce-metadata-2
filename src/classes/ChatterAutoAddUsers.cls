public class ChatterAutoAddUsers {

    @future
    public static void AddToServiceGroup(Set<Id> userId) {
    
        //Grab the group ids for each chatter group.
        List<CollaborationGroup> recG = [SELECT Id FROM CollaborationGroup WHERE Name = 'ASU Recruitment'];
        List<CollaborationGroup> servG = [SELECT Id FROM CollaborationGroup WHERE Name = 'ASU Service'];
        List<CollaborationGroup> knowG = [SELECT Id FROM CollaborationGroup WHERE Name = 'Knowledge Users'];
        
        
        //Let's create our new collaboration group objects
        List<CollaborationGroupMember> recGroup = new List<CollaborationGroupMember>();
        List<CollaborationGroupMember> marGroup = new List<CollaborationGroupMember>();
        List<CollaborationGroupMember> servGroup = new List<CollaborationGroupMember>();
        List<CollaborationGroupMember> knowGroup = new List<CollaborationGroupMember>();           
                   
        
        //Create a list to add the RECRUITMENT users
        //---------------------------------------------------
        if(recG.size() > 0) {
            List<User> recList = [SELECT Id 
                        FROM User 
                        WHERE FederationIdentifier != null 
                        AND ProfileId IN (SELECT Id FROM Profile WHERE Name = 'ASU Recruiting User') 
                        AND isActive = true 
                        AND Id NOT IN (SELECT MemberId FROM CollaborationGroupMember WHERE CollaborationGroupId = :recG[0].Id)];
        
        
            for(integer i = 0; i < recList.size(); i++)
            {
                recGroup.add(new CollaborationGroupMember (CollaborationGroupId = recG[0].Id, MemberId = recList[i].Id));  
            }
            insert recGroup;
        } 
        else {
            System.Debug('User Search for Recruitment Users Failure');
        }
        
        
        
        //Create a list to add the MARKETING users
        //---------------------------------------------------
        if(recG.size() > 0) {    
            List<User> marList = [SELECT Id 
                        FROM User 
                        WHERE FederationIdentifier != null 
                        AND ProfileId IN (SELECT Id FROM Profile WHERE Name = 'ASU Marketing User') 
                        AND isActive = true 
                        AND Id NOT IN (SELECT MemberId FROM CollaborationGroupMember WHERE CollaborationGroupId = :recG[0].Id)];
        
            for(integer i = 0; i < marList.size(); i++)
            {
                marGroup.add(new CollaborationGroupMember (CollaborationGroupId = recG[0].Id, MemberId = marList[i].Id));  
            }
            insert marGroup;
        }
        else {
            System.Debug('User Search for Marketing Users Failure');
        }
        
        
        
        //Create a list to add the KNOWLEDGE users
        //---------------------------------------------------
        if(knowG.size() > 0) {    
            List<User> knowList = [SELECT Id 
                        FROM User 
                        WHERE FederationIdentifier != null 
                        AND ProfileId IN (SELECT Id FROM Profile WHERE Name = 'ASU Knowledge User') 
                        AND isActive = true 
                        AND Id NOT IN (SELECT MemberId FROM CollaborationGroupMember WHERE CollaborationGroupId = :knowG[0].Id)];
        
            for(integer i = 0; i < knowList.size(); i++)
            {
                knowGroup.add(new CollaborationGroupMember (CollaborationGroupId = knowG[0].Id, MemberId = knowList[i].Id));  
            }
            insert knowGroup;
        }
        else {
            System.Debug('User Search for Knowledge Users Failure');
        }
        
        
        
        //Create a list to add the SERVICE users
        //---------------------------------------------------
        if(servG.size() > 0) {
            List<User> servList = [SELECT Id 
                        FROM User 
                        WHERE FederationIdentifier != null 
                        AND ProfileId IN (SELECT Id FROM Profile WHERE Name LIKE 'ASU Service%') 
                        AND isActive = true 
                        AND Id NOT IN (SELECT MemberId FROM CollaborationGroupMember WHERE CollaborationGroupId = :servG[0].Id)];
        
            for(integer i = 0; i < servList.size(); i++)
            {
                servGroup.add(new CollaborationGroupMember (CollaborationGroupId = servG[0].Id, MemberId = servList[i].Id));  
            }
            insert servGroup;
        }
        else {
            System.Debug('User Search for Service Users Failure');
        }
    }
}