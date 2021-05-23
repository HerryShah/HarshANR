@isTest
public class BatchMassDeleteRecsTest {
	static testMethod void testMethod1() 
	{
	
		Account objAccount = new Account();
        objAccount.Name = 'testacct1';
        insert objAccount;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.AccountId = objAccount.id;
        objOpportunity.StageName = 'Graveyard';
        objOpportunity.CloseDate = date.today()-50;
        objOpportunity.Name = 'test oppty1';
        objOpportunity.Amount= 500;
        insert objOpportunity;
		
		Test.startTest();

			DataBase.executeBatch(new BatchMassDeleteRecs('select AccountId,All_Traffic_Sources__c,Amount,gaconnector_Browser__c,zuevsoftware__Calculated_Amount_1__c,gaconnector_City__c,CloseDate,gaconnector_Country__c,CreatedById,Description,gaconnector_Device__c,Email__c,Financial_Capacity__c,gaconnector_First_Click_Campaign__c,gaconnector_First_Click_Channel__c,gaconnector_First_Click_Content__c,gaconnector_First_Click_Landing_Page__c,gaconnector_First_Click_Medium__c,gaconnector_First_Click_Referrer__c,gaconnector_First_Click_Source__c,gaconnector_First_Click_Term__c,Follow_Up__c,ForecastCategoryName,GA_Client_ID_Formula__c,zuevsoftware__GA_Client_ID__c,gaconngaconnector_GCLIDector_GCLID__c,GCLID__c,zuevsoftware__gaconnector_Google_Analytics_Client_ID__c,gaconnector_Google_Analytics_Client_ID__c,gaconnector_Google_Analytics_Link__c,zuevsoftware__Google_Analytics_Tracking_ID__c,How_can_we_help_you__c,gaconnector_IP_Address__c,gaconnector_Last_Click_Campaign__c,gaconnector_Last_Click_Channel__c,gaconnector_Last_Click_Content__c,gaconnector_Last_Click_Landing_Page__c,gaconnector_Last_Click_Medium__c,gaconnector_Last_Click_Referrer__c,gaconnector_Last_Click_Source__c,Last_Click_Source_Medium__c,gaconnector_Last_Click_Term__c,LastModifiedById,Last_Stage_Change_Date__c,gaconnector_Latitude_from_IP__c,LeadSource,gaconnector_Location_approx__c,gaconnector_Longitude__c,NextStep,No_of_Days_Stage_was_Changed__c,gaconnector_Number_of_Website_Visits__c,gaconnector_Operating_System__c,Name,OwnerId,Original_lead_message__c,gaconnector_Pages_visited__c,Phone__c,Pricebook2Id,CampaignId,Probability,zuevsoftware__Profit__c,Second_Contact_Attempt_Email_Sent__c,Second_Contact_Attempt_Email_Sent_Date__c,zuevsoftware__Some_Number__c,zuevsoftware__Some_Text__c,StageName,gaconnector_Time_Spent_on_Website__c,gaconnector_Time_Spent_on_Website_formul__c,gaconnector_Time_Zone__c,Type from Opportunity where closedate < LAST_N_DAYS:45 and StageName IN (\'Treatment date Scheduled!\',\'ICU\',\'Graveyard\')'));

		Test.stopTest();
		
	}
}