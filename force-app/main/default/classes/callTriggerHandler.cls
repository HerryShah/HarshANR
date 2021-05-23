public class callTriggerHandler {
    
    
    public static void afterInsert(List<Calls__c> newCallsList){
        
        
        set<Id> leadIds = new set<Id>();
        set<Id> contactIds = new Set<Id>();
        List<Event> eventsList = new List<Event>();
        Map<Id,Lead> leadMaps = new Map<Id,Lead>();
        
        
        for(Calls__c obj : newCallsList){
            
            if(obj.Lead__c != null){
                leadIds.add(obj.Lead__c);
            }
        
        }
        
        for(Lead obj : [SELECT Id,ConvertedContactId,ConvertedAccountId,ConvertedOpportunityId FROM Lead WHERE Id IN:leadIds AND isConverted =TRUE]){
            
            leadMaps.put(obj.Id,obj);
            contactIds.add(obj.ConvertedContactId);
        }
        
        Map<Id,Contact> contactMap = new Map<Id,Contact>([SELECT Id,Name,OwnerId FROM Contact WHERE Id IN: contactIds]);
        
        
        for(Calls__c obj : newCallsList){
            
            if(obj.Lead__c != null && leadMaps.containsKey(obj.Lead__c)){
                
                Event eventObj = new Event();
                eventObj.Type = 'Call';
                eventObj.Subject = 'Call';
                eventObj.Description = ''; //string
               
                if(leadMaps.get(obj.Lead__c).ConvertedOpportunityId != null){
                
                    eventObj.WhatId = leadMaps.get(obj.Lead__c).ConvertedOpportunityId; //record id
                
                } else {
                
                    eventObj.WhatId = leadMaps.get(obj.Lead__c).ConvertedAccountId; //record id
                
                }
                
                eventObj.WhoId = leadMaps.get(obj.Lead__c).ConvertedContactId; //contact
                if(contactMap.containsKey(eventObj.WhoId)){
                    
                     eventObj.OwnerId = contactMap.get(eventObj.WhoId).OwnerId;
                
                }
                
                eventObj.StartDateTime = obj.Start_Time__c;
                eventObj.EndDateTime = obj.Start_Time__c.addMinutes(Integer.valueOf(obj.Duration__c));
                
                eventsList.add(eventObj);
                
                 
            }
        
        }
        
        if(!eventsList.isEmpty()){
            insert eventsList;
        }
        
        
    
    }
    
    
}