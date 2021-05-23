@isTest
public class sendFollowupTest
{
    @isTest
    public static void sendtest()
    {
        List<Id> opps=new List<Id>();
         
        Contact c= new Contact();
        c.LastName= 'Bob';
        c.FirstName= 'M';
        c.Email='aamir@bugendaitech.com';
        
        insert c;
        
        Opportunity op= new Opportunity();
        op.Name= 'Test ops';
        op.ContactId=c.Id;
        op.StageName='First Contact Attempt';
        op.CloseDate=Date.today()+199;
        insert op;
        opps.add(op.Id);
        
        OpportunityContactRole ocr= new OpportunityContactRole();
        ocr.ContactId=c.Id;
        ocr.OpportunityId=op.Id;
        ocr.Role ='Primary';
        ocr.IsPrimary= true;
        insert ocr;
        
        
        Test.startTest();
        sendFollowup.sendSurvey(opps);
        Test.stopTest();
        
        
        
    }

}