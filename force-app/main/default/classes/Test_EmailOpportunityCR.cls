@isTest (SeeAllData=true)
private class Test_EmailOpportunityCR {
static testMethod void Test_ECR(){
// get opportunity contact role values
List<String> CRList= new List<String>();
Schema.DescribeFieldResult fieldResult = OpportunityContactRole.Role.getDescribe();
List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
for( Schema.PicklistEntry pickListVal : ple){
CRList.add(pickListVal.getLabel());
} 
integer CRCount = CRList.size()>3?3:CRList.size();

system.debug(crlist);

//create account
account a = new account(name='Test',BillingCountry='USA');
insert a;

//create contacts
list<contact> cons = new list<contact>();
for (Integer i = 0; i < CRCount; i++){
contact c = new contact(firstname='Test', lastname='Test'+i,email='test'+i+'@test.com', accountid=a.id);
cons.add(c);
}
insert cons;

//opportunity
opportunity o = new opportunity(name='test',accountid=a.id,closedate=system.today(),stagename='Payment Requested');
insert o;

//opportunity contact roles
list<opportunitycontactrole> ocrs = new list<opportunitycontactrole>();
for (Integer i = 0; i < CRCount; i++){
opportunitycontactrole ocr = new opportunitycontactrole(contactid=cons[i].id,role=CRList[i],opportunityid=o.id);
ocrs.add(ocr);
}
ocrs[0].isprimary = true;
insert ocrs;

list<EmailOpportunityContactRole.OCREmailParameters> OCREPs= new list<EmailOpportunityContactRole.OCREmailParameters>();
EmailOpportunityContactRole.OCREmailParameters OCREP = new EmailOpportunityContactRole.OCREmailParameters();
OCREP.OpportunityId = o.id;
OCREP.TemplateId = [select id from emailtemplate where isActive=true limit 1][0].id;
OCREP.toRoleNames = CRList[0];
if(CRCount > 1){
OCREP.ccRoleNames = CRList[1];
} else {
OCREP.ccRoleNames = 'Primary';
}
if(CRCount > 2){
OCREP.bccRoleNames= CRList[2];
}
//OCREP.displayName ='Hank';
OCREP.ccemails ='Hank@test.com';
OCREP.bccemails ='Hank2@test.com';
OCREP.replyTo = 'test@test.com';
list<staticresource> SRList = [Select id from StaticResource limit 1];
if(!SRList.isEmpty()){
OCREP.ResourceToAttachId = SRList[0].id; 
} 
OCREPS.add(OCREP);

EmailOpportunityContactRole.SendToOppConRoles(OCREPS); 
}
}