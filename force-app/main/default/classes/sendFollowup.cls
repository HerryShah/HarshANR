public class sendFollowup {
    
    @InvocableMethod(label='sendFollowup' description='Followup')
    
    public static void sendSurvey(List<Id> ids) {
        
        
         List<OrgWideEmailAddress> owdList = [SELECT id,address,displayname from OrgWideEmailAddress 
                                                WHERE address ='contact@anrclinicus.com' LIMIT 1];
                                                
        List<Messaging.SingleEmailMessage> massages = new List<Messaging.SingleEmailMessage>();
        
        // Step 0: Create a master list to hold the emails we'll send
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
  
        list<opportunitycontactrole> OCRs = [select contactid, isprimary,
        contact.firstname, contact.email, role from opportunitycontactrole
            where isdeleted = false and opportunityid in :ids and contact.email != null and
            (role =:'Primary' or isprimary = true)];
        
        
        
        for(opportunitycontactrole sc: OCRs){
            if (sc.contact.Email != null && sc.contact.FirstName != null) {
                // Step 5. Add your email to the master list
                mails.add(sendEmail(sc.contact.email, sc.contact.firstname));
                system.debug('mails==='+mails);
                
            }
        }
        
        // Step 6: Send all emails in the master list
        Messaging.sendEmail(mails);
    }
    
    public static Messaging.SingleEmailMessage sendEmail(String strEmail, String strCFName){
        // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = 
        new Messaging.SingleEmailMessage();
        
        List<String> sendTo = new List<String>();
        sendTo.add(strEmail);
        mail.setToAddresses(sendTo);

        // Step 3: Set who the email is sent from
        mail.setReplyTo('contact@anrclinicus.com');
        mail.setSenderDisplayName('ANR Clinic');
        mail.setSaveAsActivity(true);

        // (Optional) Set list of people who should be CC'ed
        /*List<String> ccTo = new List<String>();
        ccTo.add('business@bankofnigeria.com');
        mail.setCcAddresses(ccTo); ---------TBD*/
        
        EmailTemplate emailTemplateObj = [SELECT Id
                                                , Name
                                                , Subject
                                                , Body
                                                , HtmlValue
                                                , TemplateType
                                                , BrandTemplateId
                                            FROM 
                                                EmailTemplate 
                                            WHERE 
                                                Name = 'ANR Treatment - Follow-Up Message' 
                                            LIMIT 1 ];
                                            
                                            
                                            
                        String contentValue = emailTemplateObj.htmlValue;
                        String subject = emailTemplateObj.Subject;
                        //Label.Survey_Link+strCId+'&caId='+strCaId // {surveyLink}
                        
                        
        
        
        // Step 4. Set email contents - you can use variables!
        mail.setSubject(subject);
        
        mail.setHtmlBody(contentValue);
        
        system.debug('mail==='+mail);
        
        return mail;
        
    }
}