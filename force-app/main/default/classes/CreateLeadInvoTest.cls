@isTest
public class CreateLeadInvoTest {
	@isTest	
    static void testCreateLeadInvo(){
        
        String recTypeIdForm = Schema.SObjectType.Form__c.getRecordTypeinfosbyName().get('Questionnaire Form').getRecordTypeId();
        String recTypeIdLead = Schema.SObjectType.Lead.getRecordTypeinfosbyName().get('Questionnaire Form').getRecordTypeId();
        
        Form__c objForm = new Form__c();
        objForm.Customer_Name__c = 'Testleadinvo123456';
        objForm.Email__c = 'testleadinvo1245780000@gmail.com';
        objForm.Phone__c = '12457845126985';
        objForm.Name__c = '221144512124';
        objForm.RecordTypeId = recTypeIdForm;
        objForm.LeadRecordtypeId__c = recTypeIdLead;
        insert objForm;
        
        Account objAccount = new Account();
        objAccount.Name = 'Testleadinvo123456';
        insert objAccount;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objAccount.id;
        objOpportunity.StageName = 'Interested in ANR';
        objOpportunity.CloseDate = date.today();
        objOpportunity.Name = 'Testleadinvo123456';
        objOpportunity.Amount= 500;
        insert objOpportunity;
        
        CreateLeadInvo.DataWrapper dwarpper = new CreateLeadInvo.DataWrapper();
        
        dwarpper.formid = objForm.id;
        
        List<CreateLeadInvo.DataWrapper> lstdwrapper = new List<CreateLeadInvo.DataWrapper>();
        lstdwrapper.add(dwarpper);
        Test.startTest();
            CreateLeadInvo.CreateNewLead(lstdwrapper);
        CreateLeadInvo.dummymethod();
        Test.stopTest();
        
    }
}