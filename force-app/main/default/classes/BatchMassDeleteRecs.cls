Global class BatchMassDeleteRecs Implements Database.batchable<sobject>{
     global final string query;
     global BatchMassDeleteRecs(string q){
		  query=q;
     }
   
     global Database.QueryLocator start(Database.BatchableContext BC){

      return Database.getQueryLocator(query);
     }
     global  void execute(Database.BatchableContext BC,List<SObject> scope){
         List<Backup_Opportunities__c> lstBacOppo = new List<Backup_Opportunities__c>();
        for(Sobject s : scope){
            Opportunity curoppo = (Opportunity) s;
        	Backup_Opportunities__c objBacOppo = new Backup_Opportunities__c();
            objBacOppo.Account__c = curoppo.AccountId;
            objBacOppo.Amount__c = curoppo.Amount;
            objBacOppo.Close_Date__c = curoppo.CloseDate;
            objBacOppo.Description__c = curoppo.Description;
            objBacOppo.Email__c = curoppo.Email__c;
            objBacOppo.Financial_Capacity__c = curoppo.Financial_Capacity__c;
            objBacOppo.Follow_Up__c = curoppo.Follow_Up__c;
            objBacOppo.Forecast_Category__c = curoppo.ForecastCategoryName;
            objBacOppo.Browser__c = curoppo.gaconnector_Browser__c;
            objBacOppo.City__c = curoppo.gaconnector_City__c;
            objBacOppo.Country__c = curoppo.gaconnector_Country__c;
            objBacOppo.Device__c = curoppo.gaconnector_Device__c;
            objBacOppo.First_Click_Campaign__c = curoppo.gaconnector_First_Click_Campaign__c;
            objBacOppo.First_Click_Channel__c = curoppo.gaconnector_First_Click_Channel__c;
            objBacOppo.First_Click_Content__c = curoppo.gaconnector_First_Click_Content__c;
            objBacOppo.First_Click_Landing_Page__c = curoppo.gaconnector_First_Click_Landing_Page__c;
            objBacOppo.First_Click_Medium__c = curoppo.gaconnector_First_Click_Medium__c;
            objBacOppo.First_Click_Referrer__c = curoppo.gaconnector_First_Click_Referrer__c;
            objBacOppo.First_Click_Source__c = curoppo.gaconnector_First_Click_Source__c;
            objBacOppo.First_Click_Term__c = curoppo.gaconnector_First_Click_Term__c;
            objBacOppo.Google_Analytics_Client_ID__c = curoppo.gaconnector_Google_Analytics_Client_ID__c;
            //objBacOppo.Google_Analytics_Link__c = curoppo.gaconnector_Google_Analytics_Link__c;
            objBacOppo.IP_Address__c = curoppo.gaconnector_IP_Address__c;
            objBacOppo.Last_Click_Campaign__c = curoppo.gaconnector_Last_Click_Campaign__c;
            objBacOppo.Last_Click_Channel__c = curoppo.gaconnector_Last_Click_Channel__c;
            objBacOppo.Last_Click_Content__c = curoppo.gaconnector_Last_Click_Content__c;
            objBacOppo.Last_Click_Landing_Page__c = curoppo.gaconnector_Last_Click_Landing_Page__c;
            objBacOppo.Last_Click_Medium__c = curoppo.gaconnector_Last_Click_Medium__c;
            objBacOppo.Last_Click_Referrer__c = curoppo.gaconnector_Last_Click_Referrer__c;
            objBacOppo.Last_Click_Source__c = curoppo.gaconnector_Last_Click_Source__c;
            objBacOppo.Last_Click_Term__c = curoppo.gaconnector_Last_Click_Term__c;
            objBacOppo.Latitude__c = curoppo.gaconnector_Latitude_from_IP__c;
            //objBacOppo.Location_approx__c = curoppo.gaconnector_Location_approx__c;
            objBacOppo.Longitude__c = curoppo.gaconnector_Longitude__c;
            objBacOppo.Number_of_Website_Visits__c = curoppo.gaconnector_Number_of_Website_Visits__c;
            objBacOppo.Operating_System__c = curoppo.gaconnector_Operating_System__c;
            objBacOppo.Pages_visited__c = curoppo.gaconnector_Pages_visited__c;
            //objBacOppo.gaconnector_Time_Spent_on_Website_formul__c = curoppo.gaconnector_Time_Spent_on_Website_formul__c;
            objBacOppo.Time_Zone__c = curoppo.gaconnector_Time_Zone__c;
            objBacOppo.GCLID__c = curoppo.gaconngaconnector_GCLIDector_GCLID__c;
            //objBacOppo.GA_Client_ID_Formula__c = curoppo.GA_Client_ID_Formula__c;
            objBacOppo.GCLID_Google_Ads__c = curoppo.GCLID__c;
            objBacOppo.How_can_we_help_you__c = curoppo.How_can_we_help_you__c;
            //objBacOppo.Last_Click_Source_Medium__c = curoppo.Last_Click_Source_Medium__c;
            objBacOppo.Last_Stage_Change_Date__c = curoppo.Last_Stage_Change_Date__c;
            objBacOppo.Lead_Source__c = curoppo.LeadSource;
            objBacOppo.Opportunity_Name__c = curoppo.Name;
            objBacOppo.Name = curoppo.Name;
            objBacOppo.Next_Step__c = curoppo.NextStep;
            //objBacOppo.No_of_Days_Stage_was_Changed__c = curoppo.No_of_Days_Stage_was_Changed__c;
            objBacOppo.Original_lead_message__c = curoppo.Original_lead_message__c;
            objBacOppo.Phone__c = curoppo.Phone__c;
            objBacOppo.Second_Contact_Attempt_Email_Sent_Date__c = curoppo.Second_Contact_Attempt_Email_Sent_Date__c;
            objBacOppo.Second_Contact_Attempt_Email_Sent__c = curoppo.Second_Contact_Attempt_Email_Sent__c;
            objBacOppo.Stage__c = curoppo.StageName;
            objBacOppo.Type__c = curoppo.Type;
            objBacOppo.Google_Analytics_Client_ID__c = curoppo.zuevsoftware__gaconnector_Google_Analytics_Client_ID__c;
            objBacOppo.GA_Client_ID_package__c = curoppo.zuevsoftware__GA_Client_ID__c;
            lstBacOppo.add(objBacOppo);
        }
        System.debug(lstBacOppo+'lstBacOppo');
        insert lstBacOppo;
         
         delete scope;
    
    }
    global void finish(Database.BatchableContext BC){
    }

 }