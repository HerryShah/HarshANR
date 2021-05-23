@isTest
public class BatchMassDeleteRecsSchedulerTest {
    static testMethod void testMethod1(){
        Test.startTest();
        BatchMassDeleteRecsScheduler sh1 = new BatchMassDeleteRecsScheduler();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest();
    } 
}