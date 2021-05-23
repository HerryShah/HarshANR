@isTest
private class GenerateFormPDFExtTest {

    
    @isTest static void testMethod1() {
        
           //Id recordTypeId = Schema.SObjectType.Form__c.getRecordTypeInfosByName().get('Questionnaire Form').getRecordTypeId();
           String recTypeIdForm = Schema.SObjectType.Form__c.getRecordTypeinfosbyName().get('Questionnaire Form').getRecordTypeId();
           String recTypeIdLead = Schema.SObjectType.Lead.getRecordTypeinfosbyName().get('Questionnaire Form').getRecordTypeId();         
        
           Form__c objForm = new Form__c(RecordTypeId = recTypeIdForm);
           objForm.Customer_Name__c = 'testacct11';
            objForm.Email__c = 'test01202154241541242141@gmail.com';
            objForm.Phone__c = '12345678922415541';
            objForm.Name__c = 'testacct0000';
        	objForm.RecordTypeId = recTypeIdForm;
        	objForm.LeadRecordtypeId__c = recTypeIdLead;
            insert objForm;
           
            Account objAccount = new Account();
        objAccount.Name = 'testacct11001112';
        insert objAccount;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objAccount.id;
        objOpportunity.StageName = 'Interested in ANR';
        objOpportunity.CloseDate = date.today();
        objOpportunity.Name = 'testacct11567890';
        objOpportunity.Amount= 500;
        insert objOpportunity;
        
            PageReference pageRef = Page.GenerateFormPdf;
            pageRef.getparameters().put('id', objForm.id);  
            Test.setCurrentPage(pageRef);
            
            Apexpages.StandardController sc = new Apexpages.StandardController(objForm);
            GenerateFormPDFExt ext = new  GenerateFormPDFExt(sc);         
            ext.getPrintableView();         
        
    }
    
         
    
}