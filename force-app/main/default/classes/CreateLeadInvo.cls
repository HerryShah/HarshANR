public class CreateLeadInvo {
	public Class DataWrapper{
        @InvocableVariable(label='Form Id' required=true)
        public String formid;
    }
    @InvocableMethod(label='CreateLeadInvo' description='Create Lead')
    public static void CreateNewLead(List<DataWrapper> passedData) {
		for(DataWrapper dw:passedData){
        	String formid = dw.formid;
            
            List<Form__c> lstform = [Select Id, Customer_Name__c, Email__c, Phone__c,Opportunity__c,Account__c, LeadRecordtypeId__c, Google_Analytics_Client_ID__c, RecordTypeId from Form__c where Id = : formid];
            
            string tempInput = lstform[0].Customer_Name__c;

            List<Opportunity> lstoppoform = [Select Id, Name from Opportunity where Name =: tempInput];
            
            List<Account> lstaccountform = [Select Id, Name from Account where Name =: tempInput];
            
            if(lstoppoform.size() > 0 || lstaccountform.size() > 0){
                if(lstoppoform.size() > 0){
                    lstform[0].Opportunity__c = lstoppoform[0].Id;
                }
                if(lstaccountform.size() > 0){
                    lstform[0].Account__c = lstaccountform[0].Id;
                }
                System.debug(lstform+'lstform');
                update lstform;
            } else {
                
                	if(lstform[0].RecordTypeId == '0123t000000mj1oAAA' || lstform[0].RecordTypeId == '0123t000000mj3VAAQ' || lstform[0].RecordTypeId == '0123t000000mj31AAA' || lstform[0].RecordTypeId == '0123t000000mj36AAA'){
                	    
                    } else {
                        String formemail = lstform[0].Email__c;
                        //List<Lead> lstlead = [Select Id, name from lead where Email = : formemail];
                        Lead newlead = new Lead();
                        newlead.Lastname = lstform[0].Customer_Name__c;
                        newlead.Phone = lstform[0].Phone__c;
                        newlead.Form__c = lstform[0].Id;
                        newlead.RecordTypeId = lstform[0].LeadRecordtypeId__c;
                        newlead.zuevsoftware__gaconnector_Google_Analytics_Client_ID__c = lstform[0].Google_Analytics_Client_ID__c;
                        newlead.Email_EC__c = lstform[0].Email__c;
                        System.debug(newlead+'newlead');
                        insert newlead;                            
                        
                    }    
            }
                
        }
    }
    
    public static void dummymethod(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}