@isTest
private class GenerateLeadPDFExt_Test {

    
    @isTest static void testMethod1() {
        
           Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Calls').getRecordTypeId();
                    
           Lead objLead = new Lead(RecordTypeId = recordTypeId);
           objLead.FirstName = 'Test FirstName';
           objLead.LastName = 'Last name'; 
           objLead.Phone = '121232';
           objLead.Status = 'New';
           objLead.LeadSource = 'Calls';
           insert objLead;
           
            PageReference pageRef = Page.GenerateLeadPDF;
            pageRef.getparameters().put('id', objLead.id);  
            Test.setCurrentPage(pageRef);
            
            Apexpages.StandardController sc = new Apexpages.StandardController(objLead);
            GenerateLeadPDFExt ext = new  GenerateLeadPDFExt (sc);         
            ext.getPrintableView();         
        
    }
    
         
    
}