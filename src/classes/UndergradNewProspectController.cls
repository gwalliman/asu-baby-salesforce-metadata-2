/*
* Name: UndergradNewProspectController.cls
* Written by: Mathew Ruff
* Date Created: Oct. 2, 2014
*
* Last Updated: Nov. 26, 2014
* Updated by: Mathew Ruff
* What was Changed: Reverting to VF tab.
*/

public class UndergradNewProspectController {

    
    Contact contact;
    Opportunity opportunity;
    CampaignMember camMemInterest;
    CampaignMember camMemEvent;
    Previous_Education__c previousEducation;
    Case c;

    public Id selectedInterestId { get;set; }
    public Id Accid;
    public List<Account> instList;
    public Id elId { get;set; }
    public String eventName { get;set; }
    public Id InstId { get;set; }
    public String pickSelection { get;set; }
    public String originSelection { get;set; }
    public Boolean smsText { get;set; }

    public Id oppRecType;
    public Id walkInOrig;
    public Id phoneOrig;
    public Id emailOrig;
    
    List<Campaign> eventList;
    public String eventSearchString { get;set; }


    public void setContact(Contact contact){
        this.contact = contact;
    }
    public void setOpportunity(Opportunity opportunity){
        this.opportunity = opportunity;
    }

    public void setPreviousEducation(Previous_Education__c previousEducation){
        this.previousEducation = previousEducation;
    }

    public void setCampaignMemberInterest(CampaignMember camMemInterest) {
        this.camMemInterest = camMemInterest;
    }

    public void setCampaignMemberEvent(CampaignMember camMemEvent) {
        this.camMemEvent = camMemEvent;
    }

    public void setCase(Case c){
        this.c = c;
    }


    public Contact getContact(){
        if(contact == null) contact= new Contact();
        return contact;
    }

    public Opportunity getOpportunity() {
        if(opportunity == null) opportunity = new Opportunity();
        oppRecType = [SELECT Id FROM RecordType WHERE Name = 'Undergraduate Prospect' LIMIT 1].Id;
        opportunity.RecordTypeId = oppRecType;
        return opportunity;
    }

    public Previous_Education__c getPreviousEducation() {
        if(previousEducation == null) previousEducation = new Previous_Education__c();
        return previousEducation;
    }

    public CampaignMember getCampaignMemberInterest() {
        if(camMemInterest == null) camMemInterest = new CampaignMember();
        return camMemInterest;
    }

    public CampaignMember getCampaignMemberEvent() {
        if(camMemEvent == null) camMemEvent = new CampaignMember();
        return camMemEvent;
    }

    public Case getC() {
        if(c == null) c = new Case();
        return c;
    }
    

    //Get our event list
    public List<Campaign> getEventList() {
        return eventList;
    }

    //Search for the event.
    public void eventSearch() {
        Id eventRecId = [SELECT Id FROM RecordType WHERE Name = 'Event'].Id;
        Id eossRecId = [SELECT Id FROM RecordType WHERE Name = 'EOSS Event'].Id;
        String searchQuery = 'SELECT Id, Name, Type, Category__c, Event_Start_Date__c, Event_Start_Time__c, Campus_Location__c, Event_Location__c, RecordTypeId FROM Campaign WHERE (Name LIKE \'%' + String.escapeSingleQuotes(eventSearchString) + '%\' OR Type LIKE \'%' + String.escapeSingleQuotes(eventSearchString) + '%\' OR Category__c LIKE \'%' + String.escapeSingleQuotes(eventSearchString) + '%\') AND (RecordTypeId = :eventRecId OR RecordTypeID = :eossRecId) AND IsActive = true ORDER BY Name ASC LIMIT 40';
        eventList = Database.query(searchQuery);
    }
    
    //Get out Institution List
    public List<Account> getInstList() {
        return instList;
    }

    //Grab the Account info for the previous Institution
    public void instSearch() {
        String instSearchTerm = 'SELECT Id, Name, BillingCity, BillingState, Institution_Type__c FROM Account WHERE Id = ' + instId;
        instList = Database.query(instSearchTerm);
    }


    //Select list for ASU Location interest type
    public List<SelectOption> getASULocationIntList() {
        Id interestRecId = [SELECT Id FROM RecordType WHERE Name = 'Interest'].Id;
        List<Campaign> interests = [SELECT Id, Name, RecordTypeId FROM Campaign WHERE RecordTypeId = :interestRecId AND Type = 'ASU Location' AND IsActive = true ORDER BY Name ASC];
        List<SelectOption> asuLocationIntList = new List<SelectOption>();
        asuLocationIntList.add(new SelectOption( '' ,'--Select--'));
        for(Campaign i : interests ) {
            asuLocationIntList.add(new SelectOption(i.Id , i.Name));
        }
        return asuLocationIntList;
    }

    //Select list for Academic interest type
    public List<SelectOption> getAcademicIntList() {
        Id interestRecId = [SELECT Id FROM RecordType WHERE Name = 'Interest'].Id;
        List<Campaign> interests = [SELECT Id, Name, RecordTypeId FROM Campaign WHERE RecordTypeId = :interestRecId AND Type = 'Academic' AND IsActive = true ORDER BY Name ASC];
        List<SelectOption> academicIntList = new List<SelectOption>();
        academicIntList.add(new SelectOption( '' ,'--Select--'));
        for(Campaign i : interests ) {
            academicIntList.add(new SelectOption(i.Id , i.Name));
        }
        return academicIntList;
    }

    //Select list for ASU Colleges interest type
    public List<SelectOption> getASUCollegesIntList() {
        Id interestRecId = [SELECT Id FROM RecordType WHERE Name = 'Interest'].Id;
        List<Campaign> interests = [SELECT Id, Name, RecordTypeId FROM Campaign WHERE RecordTypeId = :interestRecId AND Type = 'ASU Colleges' AND IsActive = true ORDER BY Name ASC];
        List<SelectOption> asuCollegesIntList = new List<SelectOption>();
        asuCollegesIntList.add(new SelectOption( '' ,'--Select--'));
        for(Campaign i : interests ) {
            asuCollegesIntList.add(new SelectOption(i.Id , i.Name));
        }
        return asuCollegesIntList;
    }


    //Save method - try to insert all objects
    public Boolean save() {
        try {
            if(originSelection != '--Select--' && elId != null) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must select either ONE source OR ONE event.'));
                return false; 
            }
            else if(originSelection == '--Select--' && elId == null) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must select either ONE source OR ONE event.'));
                return false;
            }
            else if(pickSelection != '--Select--' && selectedInterestId == null) {
                System.Debug('You should see the interest error here.');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'After selecting a type of interest, you must select an interest.'));
                return false;
            }
            else {
                //Create Contact
                //-------------------------------------------------------
                contact.Id = null;
                contact.SF_First_Name__c = contact.FirstName;
                contact.SF_First_Name_Updated__c = Datetime.now();
                contact.SF_Last_Name__c = contact.LastName;
                contact.SF_Last_Name_Updated__c = Datetime.now();
                contact.SF_Mobile__c = contact.MobilePhone;
                if(smsText == true) {
                    contact.SMS_Phone__c = contact.MobilePhone;
                }
                contact.SF_Mobile_Updated__c = Datetime.now();
                contact.SF_Mailing_Street__c = contact.MailingStreet;
                contact.SF_Mailing_City__c = contact.MailingCity;
                contact.SF_Mailing_Country__c = contact.MailingCountryCode;
                contact.SF_Mailing_State__c = contact.MailingStateCode;
                contact.SF_Mailing_ZIP__c = contact.MailingPostalCode;
                contact.SF_Mailing_Address_Updated__c = Datetime.now();
                contact.SF_Birthdate__c = contact.Birthdate;
                contact.SF_Birthdate_Updated__c = Datetime.now();
                insert contact;
                System.Debug('Inserted Contact');
                System.Debug(contact);
    
    
                //Create Opportunity
                //-------------------------------------------------------
                opportunity.Id = null;
                if(oppRecType != null) {
                    opportunity.RecordTypeId = oppRecType;
                }
                else {
                    opportunity.RecordTypeId = '012d0000000x3xyAAA';
                }
                Datetime DatePreString = Datetime.now();
                String TodayString = DatePreString.format('yyyy-MM-dd');
                opportunity.Contact__c = contact.id;
                opportunity.Name = contact.FirstName + ' ' + contact.LastName + ' ' + TodayString;
                opportunity.CloseDate = Date.Today()+365;
                AccId = [SELECT AccountId FROM Contact WHERE Id = :Contact.Id][0].AccountId;
                opportunity.AccountId = AccId;
                opportunity.Career__c = 'Undergraduate';
                opportunity.StageName = 'Prospect';
                if(contact.Country_of_Citizenship__r.Name == 'United States') {
                    opportunity.International_Student__c = false;
                }
                else if(contact.Country_of_Citizenship__c == null) {
                    opportunity.International_Student__c = false;
                }
                else {
                    opportunity.International_Student__c = true;
                }
                insert opportunity;
                System.Debug('Inserted Opportunity');
                System.Debug(opportunity);
    
    
                //Create Previous Education
                //-------------------------------------------------------
                if(previousEducation.Account__c != null) {
                    getPreviousEducation();
                    previousEducation.Id = null;
                    previousEducation.Contact__c = contact.id;
                    insert previousEducation;
                    System.Debug('Inserted Previous Education');
                    System.Debug(previousEducation);
                }
    
    
                //Create CampaignMember Event
                //-------------------------------------------------------
                if(elId != null && originSelection == '--Select--') {
                    getCampaignMemberEvent();
                    camMemEvent.Id = null;
                    camMemEvent.CampaignId = elId;
                    camMemEvent.Status = 'Registered';
                    camMemEvent.ContactId = contact.Id;
                    camMemEvent.Opportunity__c = opportunity.Id;
                    camMemEvent.Inbound_Interaction__c = true;
    
                    insert camMemEvent;
                    System.Debug('Inserted an Event Campaign Member');
                    System.Debug(camMemEvent);
                }
                //Create Case
                //-------------------------------------------------------
                else if(originSelection != '--Select--' && elId == null) {
                    getC();
                    c.Id = null;
                    c.Status = 'Closed: Resolved';
                    Id asuAdmissionRecId = [SELECT Id, Name FROM RecordType WHERE Name = 'ASU Admission Services' LIMIT 1].Id;
                    c.RecordTypeId = asuAdmissionRecId;
                    c.ContactId = contact.Id;
                    c.Opportunity__c = opportunity.Id;
                    if(originSelection == 'Incoming Call') {
                      if(phoneOrig == null) {
                      phoneOrig = [SELECT Id FROM Campaign WHERE Name = 'Phone Call' LIMIT 1].Id;
                          c.Case_Source__c = phoneOrig;
                      }
                    }
                    else if(originSelection == 'Email') {
                      if(emailOrig == null) {
                        emailOrig = [SELECT Id FROM Campaign WHERE Name = 'Email' LIMIT 1].Id;
                          c.Case_Source__c = emailOrig;
                      }
                    }
                    else {
                      if(walkInOrig == null) {
                        walkInOrig = [SELECT Id FROM Campaign WHERE Name = 'Walk In' LIMIT 1].Id;
                          c.Case_Source__c = walkInOrig;
                        }
                    }
                    c.Origin__c = originSelection;
                    c.Inbound_Interaction__c = true;
                    c.Priority = 'Normal';
                    String termName = [SELECT Term__r.Name FROM Opportunity WHERE Term__c = :opportunity.Term__c LIMIT 1].Term__r.Name;
                    if(c.Description == null) {
                        c.Subject = c.Origin__c + ' Submission - ' + termName;
                    }
                    insert c;
                    System.Debug('Inserted Case');
                    System.Debug(c);
                    
                    //Update Opportunity's case with case Id
                    //-------------------------------------------------------
                    opportunity.Prospect_Case__c = c.Id;
                    update opportunity;
                    System.Debug('Update opportuinty\'s prospect case id with the new case id.');
                    System.Debug(opportunity);
                    
                }
                else if(originSelection != '--Select--' && elId != null) {
                    return false;
                }
                else if(originSelection == '--Select--' && elId == null) {
                    return false;
                }
                else {
                    return false;
                }
                
                
                //Create CampaignMember Interest
                //-------------------------------------------------------
                if(pickSelection != '--Select--') {
                    if(selectedInterestId != null) {
                        getCampaignMemberInterest();
                        camMemInterest.Id = null;
                        camMemInterest.CampaignId = selectedInterestId;
                        camMemInterest.Status = 'Interested';
                        camMemInterest.ContactId = contact.Id;
                        camMemInterest.Opportunity__c = opportunity.Id;
        
                        insert camMemInterest;
                        System.Debug('Inserted an Interest Campaign Member');
                        System.Debug(camMemInterest);
                    }
                    else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'After selecting a type of interest, you must select an interest.'));
                        return false;
                    }
                }
                
                //Save success, return true.
                return true;
            }

        } catch(Exception e) {
            ApexPages.addMessages(e);
            System.debug('Exception type caught: ' + e.getTypeName());
            System.debug('Message: ' + e.getMessage());
            System.debug('Line number: ' + e.getLineNumber());
            System.debug('Stack trace: ' + e.getStackTraceString());
            return false;
        }
    }

    //Save
    public PageReference savePage() {
        if(save()) {
            PageReference save = new PageReference('/' + opportunity.Id);
            save.setRedirect(true);
            return save;
        }
        else {
            return null;
        }
    }
}