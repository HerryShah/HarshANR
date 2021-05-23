public class BatchforcallrailCallsScheduler  implements Schedulable,Database.AllowsCallouts {
  
  
  // This class runs a scheduled job once at 5:45 AM on the every day
    
    
    public String sched = '0 45 5 * * ? *'; //at 5:45 AM on the every day
    
    public String scheduleMe(String str) {
    
        if(str != '' && str != null){
           this.sched = str;
        }
    
        BatchforcallrailCallsScheduler SC = new BatchforcallrailCallsScheduler();
        return System.schedule('Schedule BatchforcallrailCalls', sched, SC);
    }

    public void execute(SchedulableContext sc) {
    
      Database.executeBatch(new BatchforcallrailCalls(false,true,1,30));

    }
    
}