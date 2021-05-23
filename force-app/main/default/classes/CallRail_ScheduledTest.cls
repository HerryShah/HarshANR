@isTest
public class CallRail_ScheduledTest  {

    static testMethod void myTestMethod01() {        
         test.starttest();
         BatchforcallrailCallsScheduler myClass = new BatchforcallrailCallsScheduler();   
         myClass.scheduleMe('');
         test.stopTest();
    }
    static testMethod void myTestMethod02() {        
         test.starttest();
         BatchforcallrailFormSubmissionsScheduler myClass = new BatchforcallrailFormSubmissionsScheduler();   
         myClass.scheduleMe('');
         test.stopTest();
    }
  
}