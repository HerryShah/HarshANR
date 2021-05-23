@isTest
private class callrailHelper_Test {

    //Below is a method with @testsetup annotation, the name can be anything like setup(), oneTimeData(), etc.
    @testSetup static void setup() {
        
       
                                           
    }
 
    @isTest static void testMethod1() {
        
       Database.executeBatch(new BatchforcallrailCalls(false,true,1,30));
        
    }
    
     @isTest static void testMethod2() {
        
         Database.executeBatch(new BatchforcallrailFormSubmissions(false,true,1,50));
     }
    
    
   
    
         
    
}