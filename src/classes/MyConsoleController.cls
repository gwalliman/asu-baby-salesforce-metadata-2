public class MyConsoleController {

    public MyConsoleController(TestController controller) {

    }


    public MyConsoleController(ApexPages.StandardController controller) {

    }

    public MyConsoleController(vfKeywordSearchController controller) {

    }


    public MyConsoleController(ApexPages.StandardSetController controller) {

    }
    
    public Id contId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].ContactId;
    public List<Contact> contactList = [SELECT Id, Name, EmplId__c, CAP__c, CAP_Student_Group_Count__c FROM Contact WHERE Id = :contId];

    public Case selectedCase { get; set; }
    
    public Solution[] getSolutions() {
        return [SELECT Id, SolutionNumber, SolutionName, Status FROM Solution];
    }
    
    public Case[] getMyCases() {
        // return [SELECT Id, Subject, Status, Description FROM Case WHERE OwnerId = :UserInfo.getUserId()
            // AND Status != 'Closed'];
            
        return [SELECT Id, Subject, Status, Description FROM Case WHERE IsClosed = False AND ContactId = :contId];
    }
    
    public Case[] getClosedCases() {
        // return [SELECT Id, Subject, Status, Description FROM Case WHERE OwnerId = :UserInfo.getUserId()
            // AND Status = 'Closed'];
            
        return [SELECT Id, Subject, Status, Description FROM Case WHERE IsClosed = True AND ContactId = :contId];
    }
    
    public PageReference viewCase() {
        String caseId = ApexPages.currentPage().getParameters().get('caseId');
        selectedCase = [SELECT Id FROM Case WHERE Id = :caseId];
        return new PageReference('/viewcase?id=' + caseId);
    }
    
    public PageReference viewSolution() {
        String solId = ApexPages.currentPage().getParameters().get('solId');
        return new PageReference('/' + solId);
    }
}