global class EmailOpportunityContactRole {

    @InvocableMethod(label='Send Email to Opportunity Contact Roles' description='Sends email related to an opportunity, based on opportunity contact roles')
    global static void SendToOppConRoles(list<OCREmailParameters> EParam){ 
    
        List<OrgWideEmailAddress> owdList = [SELECT id,address,displayname from OrgWideEmailAddress 
                                                WHERE address ='contact@anrclinicus.com' LIMIT 1];
                                                
        List<Messaging.SingleEmailMessage> massages = new List<Messaging.SingleEmailMessage>();
        
        for(OCREmailParameters EP: Eparam){
        
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            
            string emailsubject = '';
            string bodytext = ''; 
            
            String[] toRoles = ep.toRoleNames.split(',');
            list<string> bccRoles = new list <string>();
            if(string.isNotBlank(ep.bccRoleNames) ){ ep.bccRoleNames.split(',');}
            
            list<string> ccRoles = new list <string>();
            if(string.isNotBlank(ep.ccRoleNames) ){ ccRoles = ep.ccRoleNames.split(',');}
            
            system.debug(ccroles);
            
            list<string> toEmails = new list<string>();
            list<string> ccEmails = new list<string>();
            list<string> bccEmails = new list<string>();
            id toContact = null;
            id primaryContact = null;
            
            list<opportunitycontactrole> OCRs = [select contactid, isprimary, contact.firstname, contact.email, role from opportunitycontactrole
            where isdeleted = false and opportunityid = :ep.OpportunityId and contact.email != null and
            (role in :toroles or role in :bccroles or role in :ccroles or isprimary = true)];
            
            system.debug(OCRs);
            
            
            
            for(opportunitycontactrole OCR: OCRs){
                
                if(toRoles.contains(OCR.role) || (toRoles.contains('Primary')&&OCR.IsPrimary)){
                    if(string.isBlank(toContact)){
                    toContact = OCR.ContactId;
                    }
                    toEmails.add(OCR.Contact.Email);
                } else if (ccRoles.contains(OCR.role)|| (ccRoles.contains('Primary')&&OCR.IsPrimary)){
                    ccEmails.add(OCR.Contact.Email);
                } else if (bccRoles.contains(OCR.role)|| (bccRoles.contains('Primary')&&OCR.IsPrimary)){
                    bccEmails.add(OCR.Contact.Email);
                }
                
                if(OCR.IsPrimary){
                    primaryContact = OCR.ContactId;
                }
            }
            
            if(string.isNotBlank(ep.ccEmails) ){ 
                list<string> addEmails = ep.ccEmails.split(',');
                for(string em: addEmails){
                    string eml = em.trim();
                    if(validateEmail(eml)){
                    ccEmails.add(eml);
                    }
                }
            }
            
            if(string.isNotBlank(ep.bccEmails) ){ 
                list<string> addEmails = ep.bccEmails.split(',');
                for(string em: addEmails){
                    string eml = em.trim();
                    if(validateEmail(eml)){
                        bccEmails.add(eml);
                    }
                }
            }
            
            
            //work on contingencies if there is no "to" contact
            if(string.isblank(toContact)){
            if(!string.isblank(primaryContact)){
            toContact = primaryContact;
            } else if (!OCRs.isempty()) {
            toContact = OCRs[0].ContactID;
            toEmails.add(OCRs[0].Contact.email);
            } else {
            // if no recipients found, stop
            system.debug('No recipients found');
            return;
            }
            }
            
            email.setToAddresses( toEmails );
            if(!ccEmails.isempty()){
            email.setCCAddresses( ccEmails);
            }
            if(!bccEmails.isempty()){
            email.setBCCAddresses( bccEmails);
            }
            if(EP.saveAsActivity == null || EP.saveAsActivity){
            email.setSaveAsActivity(true);
            }
            if(EP.replyto != null){
            email.setReplyTo(EP.replyto);
            }
            if(EP.displayname != null){
            email.setSenderDisplayName(EP.displayName);
            }
            
            
            //template related settings
            email.setWhatId(ep.opportunityid);
            email.settargetObjectId(toContact);
            email.setTemplateId(ep.TemplateId);
            //email.setPlainTextBody( bodytext );
            
            if (!owdList.isEmpty()) {
                email.setOrgWideEmailAddressId(owdList[0].Id);
            }
            system.debug(email);
            
            if(ep.ResourceToAttachId!=null){
            //Attachments
            List<StaticResource> objPDF = [Select body, name from StaticResource where id = :ep.ResourceToAttachId];
            if(!objPDF.isempty()){
            Messaging.EmailFileAttachment[] objEmailAttachments = new Messaging.EmailFileAttachment[1];
            Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
            objPDFAttachment.setBody(objPDF[0].Body);
            objPDFAttachment.setFileName(objPDF[0].name + '.pdf');
            objEmailAttachments[0] = objPDFAttachment;
            email.setFileAttachments(objEmailAttachments);
            }
            }
            
            
            massages.add(email);
            
        }
        // Sends the email
        if(massages != Null && massages.isEmpty()){
            Messaging.SendEmailResult [] r = Messaging.sendEmail(massages); 
        }
        
    

    }

    public static Boolean validateEmail(String email) {
        Boolean res = true;


        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: http://www.regular-expressions.info/email.html
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);

        if (!MyMatcher.matches()) 
        res = false;
        return res; 
    }

global class OCREmailParameters {

@InvocableVariable(required=true)
global ID OpportunityId;

@InvocableVariable(required=true)
global ID TemplateId;

@InvocableVariable(required=true)
global string toRoleNames;

@InvocableVariable
global string ccRoleNames;

@InvocableVariable
global string bccRoleNames;

@InvocableVariable
global string displayName;

@InvocableVariable
global string replyTo;

@InvocableVariable
global string ccEmails;

@InvocableVariable
global string bccEmails;

@InvocableVariable
global boolean saveAsActivity; 

@InvocableVariable
global id ResourceToAttachId;

}

}