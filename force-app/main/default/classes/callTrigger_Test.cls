@isTest
private class callTrigger_Test {

    //Below is a method with @testsetup annotation, the name can be anything like setup(), oneTimeData(), etc.
    @testSetup static void setup() {
        
                                           
    }
 
    @isTest static void testMethod1() {
        
           Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Calls').getRecordTypeId();
                    
           Lead objLead = new Lead(RecordTypeId = recordTypeId);
           objLead.FirstName = 'Test FirstName';
           objLead.LastName = 'Last name'; 
           objLead.Phone = '121232';
           objLead.Status = 'New';
           objLead.LeadSource = 'Calls';
           insert objLead;
           
 
           database.leadConvert lc = new database.leadConvert();
           lc.setLeadId(objLead.id);

           leadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);

           Database.LeadConvertResult lcr = Database.convertLead(lc);   
           
           
           Calls__c objCall = new Calls__c();
            objCall.Business_Phone_Number__c = '121232';
            objCall.Customer_City__c = 'test'; 
            objCall.Customer_Name__c = 'test'; 
            objCall.Customer_Phone_Number__c = '121232'; 
            objCall.Customer_State__c = 'test';   
            objCall.Duration__c = 1;
            objCall.Id__c ='12111';  
            objCall.Start_Time__c = dateTime.now();
            objCall.Lead__c = objLead.Id;
            
            insert objCall;
             
        
    }
    
         
    
}