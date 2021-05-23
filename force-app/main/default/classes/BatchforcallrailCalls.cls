global class BatchforcallrailCalls implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.stateFul {

    public Boolean check;
    public Boolean check7Days;
    public Integer pageNumber;
    public Integer pageSize;
    public Integer numberOfPages;
    
    public String query = 'Select Id FROM USER LIMIT 1';
 
    global BatchforcallrailCalls(Boolean check7Days,Boolean check,Integer pageNumber,Integer pageSize){
     
        this.check = check;
        this.check7Days = check7Days;
        this.pageNumber = pageNumber;
        this.pageSize = pageSize;
        
    }
 
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

     global void execute(Database.BatchableContext BC, List<User> records) {    
     
        String s = '';
          
        
          try {                  
              
              
                  String response =  callrailHelper.getcallrailCallJSON(check7Days,string.valueOf(pageNumber),string.valueOf(pageSize));
                  
                  if(Test.isRunningTest()){
                      check = false;
                  }
                  
                  callrailCallJSON objcalls = callrailCallJSON.parse(response);
                  
                  List<Calls__c> callsList = new List<Calls__c>();
                  
                  numberOfPages = objcalls.total_pages;
                  
                  
                  if(objcalls.calls != null && !objcalls.calls.isEmpty()){
                    
                    set<String> phoneSet = new set<String>(); 
                    set<String> nameSet = new set<String>(); 
                    
                    for(callrailCallJSON.Calls obj: objcalls.calls){
                        
                        nameSet.add(obj.customer_name); 
                        phoneSet.add(obj.customer_phone_number); 
                        
                    }
                    
                    Map<String,Lead> nameLeadMap = new Map<String,Lead>();
                    Map<String,Lead> phoneLeadMap = new Map<String,Lead>();
                      
                    Map<String,Contact> nameContactMap = new Map<String,Contact>();
                    Map<String,Contact> phoneContactMap = new Map<String,Contact>();
                    
                    Map<String,String> conOppIdMap = new Map<String,String>();  
                    
                    Set<id> setContactIds = new Set<id>();  
                    Map<String,Patient__c> namePatientMap = new Map<String,Patient__c>();
                      
                    for(Lead obj : [SELECT Id,Name,Phone FROM Lead WHERE Name IN:nameSet OR Phone IN:phoneSet]){
                        nameLeadMap.put(obj.Name.toLowercase(),obj);
                        phoneLeadMap.put(obj.Phone,obj);
                    }
                      
                    for(Contact objCon : [SELECT Id,Name,Phone FROM Contact WHERE Name IN:nameSet OR Phone IN:phoneSet]){
                        nameContactMap.put(objCon.Name.toLowercase(),objCon);
                        phoneContactMap.put(objCon.Phone,objCon);
                        setContactIds.add(objCon.Id);
                    }  
                    
                    for(OpportunityContactRole objOppoContRole : [SELECT Id,ContactId, OpportunityId from OpportunityContactRole where ContactId IN:setContactIds]){
                        conOppIdMap.put(objOppoContRole.ContactId,objOppoContRole.OpportunityId);
                    }
                      
                    for(Patient__c objPatient : [SELECT Id,Name FROM Patient__c WHERE Name IN:nameSet]){
                        namePatientMap.put(objPatient.Name.toLowercase(),objPatient);
                    }
                      
                    Map<String,Lead> newleadMap = new Map<String,Lead>();
                    
                    for(callrailCallJSON.Calls obj: objcalls.calls){
                        
                        string name = obj.customer_name != null ? obj.customer_name.toLowercase() : '';
                        
                        if(!nameLeadMap.containsKey(name) && !phoneLeadMap.containsKey(obj.customer_phone_number)){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Calls').getRecordTypeId();
                    
                            Lead objLead = new Lead(RecordTypeId = recordTypeId);
                            
                            if(obj.customer_name != null && obj.customer_name !=''){
                                
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.customer_name);
                                //objLead.Company = obj.customer_name;
                            
                            } else {
                                
                                 objLead.LastName = obj.customer_phone_number;
                                 //objLead.Company = obj.customer_phone_number;
                            }
                           
                            objLead.Phone = obj.customer_phone_number;
                            objLead.Status = 'New';
                            objLead.LeadSource = 'Calls';
                            
                            newleadMap.put(objLead.Phone,objLead);
                            
                        }
                        
                        
                    }
                    
                    if(!newleadMap.isEmpty()){
                       
                       insert newleadMap.values();
                            
                    }
                    
                    
                    for(callrailCallJSON.Calls obj: objcalls.calls){
                        
                        Calls__c objCall = new Calls__c();
                        objCall.Answered__c = obj.answered;
                        objCall.Business_Phone_Number__c = obj.business_phone_number;
                        objCall.Customer_City__c = obj.customer_city;
                        objCall.Customer_Country__c = obj.customer_country; 
                        objCall.Customer_Name__c = obj.customer_name; 
                        objCall.Customer_Phone_Number__c = obj.customer_phone_number; 
                        objCall.Customer_State__c = obj.customer_state; 
                        objCall.Direction__c = obj.direction; 
                        objCall.Duration__c = obj.duration; 
                        objCall.Id__c = obj.id; 
                        objCall.Recording__c = obj.recording; 
                        objCall.Recording_Duration__c = obj.recording_duration; 
                        objCall.Recording_Player__c = obj.recording_player; 
                        objCall.Start_Time__c = callrailHelper.getConvertDateTime(obj.start_time); 
                        objCall.Tracking_Phone_Number__c = obj.tracking_phone_number; 
                        objCall.Voicemail__c = obj.voicemail; 
                        
                        string name = obj.customer_name != null ? obj.customer_name.toLowercase() : '';
                        
                        if(nameLeadMap.containsKey(name)){
                            
                            objCall.Lead__c = nameLeadMap.get(name).Id;
                            
                        } else if(phoneLeadMap.containsKey(obj.customer_phone_number)) {
                            
                            objCall.Lead__c = phoneLeadMap.get(obj.customer_phone_number).Id;
                            
                        } else if(newleadMap.containsKey(obj.customer_phone_number)) {
                            
                            objCall.Lead__c = newleadMap.get(obj.customer_phone_number).Id;
                            
                        }
                        
                        if(nameContactMap.containsKey(name)){
                            
                            objCall.Contact__c = nameContactMap.get(name).Id;
                            String conid = String.valueOf(nameContactMap.get(name).Id);
                            if(conOppIdMap.containsKey(conid)){
                                objCall.Opportunity__c = conOppIdMap.get(conid);
                            }    
                        } else if(phoneContactMap.containsKey(obj.customer_phone_number)) {
                            
                            objCall.Contact__c = phoneContactMap.get(obj.customer_phone_number).Id;
                            String conid = String.valueOf(phoneContactMap.get(obj.customer_phone_number).Id);
                            if(conOppIdMap.containsKey(conid)){
                                objCall.Opportunity__c = conOppIdMap.get(conid);
                            }
                        }
                        
                        if(namePatientMap.containsKey(name)){
                            
                            objCall.Patient__c = namePatientMap.get(name).Id;
                            
                        }
                        
                        callsList.add(objCall);
  

                        
                        
                    }
                    
                    system.debug('----Outside--'+callsList.size());
                    
                    if(!callsList.isEmpty()){
                    
                        system.debug('----inside--'+callsList.size());
                        upsert callsList Id__c;
                    }
                    
                      
                  } else {
                      check = false;
                  } 
                                    
                  
                           
          }
          catch (Exception e) {         
            System.debug('Error:' + e.getMessage() + 'Line Number:   ' + e.getLineNumber() );   
            
            
             check = false;
      
          }
       
    }   

    global void finish(Database.BatchableContext BC){  
    
        if(check){
            
            if(pageNumber < numberOfPages){
                
                pageNumber = pageNumber+1;
            
                Database.executeBatch(new BatchforcallrailCalls(check7Days,check,pageNumber,pageSize));

            } 
        }  
        
    }
}