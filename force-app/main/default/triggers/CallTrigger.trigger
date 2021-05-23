trigger CallTrigger on Calls__c (after insert) {
       
       
       if(Trigger.isInsert && Trigger.isAfter){
           callTriggerHandler.afterInsert(trigger.new);
       } 
}