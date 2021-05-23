global class BatchforcallrailFormSubmissions implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.stateFul {

    public Boolean check;
    public Boolean check7Days;
    public Integer pageNumber;
    public Integer pageSize;
    public Integer numberOfPages;
    
    public String query = 'Select Id FROM USER LIMIT 1';
 
    global BatchforcallrailFormSubmissions(Boolean check7Days,Boolean check,Integer pageNumber,Integer pageSize){
     
        this.check = check;
        this.check7Days = check7Days;
        this.pageNumber = pageNumber;
        this.pageSize = pageSize;
        
    }
 
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

     global void execute(Database.BatchableContext BC, List<User> records) {    
     
        String s = '';
          
        
          try {                  
              
              
                  String response =  callrailHelper.getcallrailFormSubmissionJSON(check7Days,string.valueOf(pageNumber),string.valueOf(pageSize));
                  
                  if(Test.isRunningTest()){
                      check = false;
                  }
                  
                  callrailFormSubmissionJSON objcalls = callrailFormSubmissionJSON.parse(response);
                  
                  List<Lead> leadList = new List<Lead>();
                  
                  numberOfPages = objcalls.total_pages;
                  
                  
                  if(objcalls.form_submissions != null && !objcalls.form_submissions.isEmpty()){
                    
                    
                    for(callrailFormSubmissionJSON.Form_submissions obj: objcalls.form_submissions){
                        
                        if(obj.form_url.contains('https://anrclinic.com/contact/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Contact Us').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                                objLead.Id__c = obj.id;
                            objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            //objLead.Company = obj.form_data.name;
                            objLead.Phone = obj.form_data.phone;
                            objLead.Email = (obj.form_data.email != null)?obj.form_data.email:obj.form_data.emailExtra;
                            objLead.Email_EC__c = obj.form_data.emailExtra;
                            objLead.Country__c = obj.form_data.country;
                            if(obj.form_data.How_can_we_help_you.contains('@@@')){
                                list<String> lstStr = obj.form_data.How_can_we_help_you.split('@@@');
                                objLead.How_can_we_help_you__c = lstStr[0];
                                objLead.zuevsoftware__gaconnector_Google_Analytics_Client_ID__c = lstStr[1];
                            }else{
                                objLead.How_can_we_help_you__c = obj.form_data.How_can_we_help_you;
                            }
                             
                            objLead.Select__c = obj.form_data.select1;
                            objLead.Status = 'New';
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                            objLead.Landing_Page_URL__c = obj.landing_page_url;
                            String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.LeadSource = 'Contact Us Form';
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;

                            leadList.add(objlead);
      
                        } else if(obj.form_url.contains('https://anrclinic.com/questionnaire/')){
                        
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Questionnaire Form').getRecordTypeId();
                            
                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Questionnaire';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Email_EC__c = obj.form_data.emailExtra;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                           
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            objLead.dateOfBirth__c = obj.form_data.dateOfBirth;
                            objLead.SocialSecurity__c = obj.form_data.SocialSecurity;
                            objLead.PreferredLanguage__c = obj.form_data.PreferredLanguage;
                            objLead.Sex__c  = obj.form_data.Sex;
                           
                            objLead.MaritalStatus__c  = obj.form_data.MaritalStatus;

                            objLead.Race__c = obj.form_data.Race;
                            objLead.Ethnicity__c = obj.form_data.Ethnicity;
                            objLead.PreferredPharmacy__c = obj.form_data.PreferredPharmacy;
                            
                            objLead.Location__c = obj.form_data.Location;
                            objLead.PrimaryCareDoctor__c = obj.form_data.PrimaryCareDoctor;
                            objLead.Phone = obj.form_data.Phone;
                            
                            objLead.Street__c = obj.form_data.Street;
                            objLead.City__c = obj.form_data.City;
                            objLead.State__c = obj.form_data.State;
                            objLead.Zip__c = obj.form_data.Zip;
                            objLead.Country__c = obj.form_data.Country;
                            
                            objLead.PrimaryPhone__c = obj.form_data.PrimaryPhone;
                            
                            objLead.AlternatePhone__c = obj.form_data.AlternatePhone;
                            objLead.Email = obj.form_data.Email;
                            objLead.Occupation__c = obj.form_data.Occupation;
                            objLead.FirstandLastNameEmergency__c = obj.form_data.FirstandLastName_Emergency;

                            
                            objLead.RelationshiptoPatient__c = obj.form_data.RelationshiptoPatient;
                            objLead.DrugName__c = obj.form_data.DrugName;
                            objLead.AmountPerDay__c = obj.form_data.AmountPerDay;
                            objLead.MethodofUse__c = obj.form_data.MethodofUse;
                            objLead.WhenDate__c = callrailHelper.getConvertDate(obj.form_data.WhenDate);
                            objLead.Generalremarksaboutyour__c = obj.form_data.Generalremarksaboutyourwithdrawalattempts;
                            objLead.nffield71__c = obj.form_data.nf_field_71;
                            objLead.PleaseSpecify__c = obj.form_data.Please_Specify;
                            objLead.nffield77__c = obj.form_data.nf_field_77;
                            objLead.ForHowLong__c = obj.form_data.For_How_Long;
                            objLead.nffield74__c = obj.form_data.nf_field_74;
                            objLead.nffield80__c = obj.form_data.nf_field_80;
                            objLead.Medication__c = obj.form_data.Medication;
                            
                            objLead.nffield96__c = obj.form_data.nf_field_96;
                            objLead.nffield99__c = obj.form_data.nf_field_99;
                            objLead.nffield102__c = obj.form_data.nf_field_102;
                            objLead.nffield105__c = obj.form_data.nf_field_105;
                            objLead.nffield108__c = obj.form_data.nf_field_108;
                            objLead.nffield111__c = obj.form_data.nf_field_111;
                            objLead.nffield114__c = obj.form_data.nf_field_114;
                            objLead.nffield117__c = obj.form_data.nf_field_117;
                            objLead.nffield120__c = obj.form_data.nf_field_120;
                            objLead.nffield123__c = obj.form_data.nf_field_123;
                            objLead.nffield126__c = obj.form_data.nf_field_126;
                            objLead.nffield129__c = obj.form_data.nf_field_129;
                            objLead.nffield132__c = obj.form_data.nf_field_132;
                            objLead.nffield135__c = obj.form_data.nf_field_135;
                            objLead.nffield138__c = obj.form_data.nf_field_138;
                            objLead.nffield141__c = obj.form_data.nf_field_141;
                            objLead.nffield144__c = obj.form_data.nf_field_144;
                                        
                            objLead.InstitutionorClinic__c = obj.form_data.InstitutionorClinic;
                            objLead.Haveyoueverreceivedpsychiatrictreatment__c = obj.form_data.Haveyoueverreceivedpsychiatrictreatment;
                            objLead.Please_specify_and_describe_reactions__c = obj.form_data.Pleasespecifyanddescribereactions;
                            
                            objLead.nffield236__c = obj.form_data.nf_field_236;
                            objLead.nffield239__c = obj.form_data.nf_field_239;
                            objLead.Weight__c = obj.form_data.Weight;
                            objLead.Height__c = obj.form_data.Height;                
                            objLead.Craving_scale_while_clean__c = obj.form_data.Cravingscalewhileclean;
                            objLead.Methadone_or_Suboxone_Maintenance__c = obj.form_data.MethadoneorSuboxoneMaintenance;
                            objLead.For_How_Long__c = obj.form_data.ForHowLong;
                            objLead.X1A_Have_you_ever_received_psychiatric_t__c = obj.form_data.Haveyoueverreceivedpsychiatrictreatment1A;
                            objLead.X1B_Have_you_ever_received_psychiatric_t__c = obj.form_data.Haveyoueverreceivedpsychiatrictreatment1B;
                            objLead.Prior_suicide_attempts__c = obj.form_data.Priorsuicideattempts;
                            objLead.Dose__c = obj.form_data.Dose;
                            objLead.Frequency__c = obj.form_data.Frequency;
                            objLead.Route__c = obj.form_data.Route;
                            objLead.Past_Surgeries__c = obj.form_data.PastSurgeries;
                            objLead.Hospitalization_in_the_last_two_years__c = obj.form_data.Hospitalizationinthelasttwoyears;
                            objLead.X5B_Please_specify__c = obj.form_data.Pleasespecify5B;
                            objLead.Adverse_reactions_to_anesthesia_in_the_p__c = obj.form_data.Adversereactionstoanesthesiainthepast;
                            objLead.Emergency_room_visits_in_the_last_year__c = obj.form_data.Emergencyroomvisitsinthelastyear;
                            objLead.Accidents_work_car_etc__c = obj.form_data.Accidents;
                            objLead.Head_Injuries__c = obj.form_data.HeadInjuries;
                            objLead.Loss_of_consciousness__c = obj.form_data.Lossofconsciousness;
                            objLead.Loss_of_consciousness_Seizures__c = obj.form_data.LossofconsciousnessSeizures;
                            objLead.Heart_disease__c = obj.form_data.Heartdisease;
                            objLead.Lung_disease__c = obj.form_data.Lungdisease;
                            objLead.Kidney_disease_problem__c = obj.form_data.Kidneydiseaseproblem;
                            objLead.Diabetes__c = obj.form_data.Diabetes;
                            objLead.Ulcers__c = obj.form_data.Ulcers;
                            objLead.Date__c = obj.form_data.DateDt;
                            objLead.X7B_Please_specify__c = obj.form_data.Pleasespecify7B;
                            objLead.X8B_Please_specify__c = obj.form_data.Pleasespecify8B;
                            objLead.XB_Please_specify__c = obj.form_data.Pleasespecify9B;
                            objLead.X0B_Please_specify__c = obj.form_data.Pleasespecify10B;
                            objLead.X1B_Please_specify__c = obj.form_data.Pleasespecify11B;
                            objLead.X2B_Please_specify__c = obj.form_data.Pleasespecify12B;
                            objLead.X3B_Please_specify__c= obj.form_data.Pleasespecify13B;
                            objLead.X4B_Please_specify__c = obj.form_data.Pleasespecify14B;
                            objLead.X15B_Please_specify__c = obj.form_data.Pleasespecify15B;
                            objLead.X6B_Please_specify__c = obj.form_data.Pleasespecify16B;
                            objLead.X17B_Please_specify__c = obj.form_data.Pleasespecify17B;
                            objLead.X18B_Please_specify__c = obj.form_data.Pleasespecify18B;
                            objLead.X19B_Please_specify__c = obj.form_data.Pleasespecify19B;
                            objLead.X12B_Please_specify__c = obj.form_data.Pleasespecify21B;
                            objLead.X2B_If_so_when__c= obj.form_data.Ifsowhen2B;
                            objLead.X3B_Please_specify_and_describe_reaction__c =  obj.form_data.Pleasespecifyanddescribereactions3B;
                            objLead.Allergies_Medications_Food_etc__c = obj.form_data.allergies ;
                            objLead.AlternatePhone__c = obj.form_data.AlternatePhone;
                            objLead.Asthma_or_shortness_of_breath__c = obj.form_data.Asthmaorshortness; 
                            objLead.Drug_Name_DCBU1__c = obj.form_data.DrugNameExtra;
                            objLead.Email_EC__c = obj.form_data.emailExtra;
                            objLead.High_Blood_Pressure__c = obj.form_data.highBloodPressure;
                            objLead.Obstructive_sleep_apnea__c = obj.form_data.Obstructivesleepapnea;
                            objLead.Other_Relevant_Personal_Remarks__c = obj.form_data.OtherRelevantPersonalRemarks;
                            objLead.Phone_EC__c = obj.form_data.PhoneExtra;
                            objLead.Pregnancy__c = obj.form_data.Pregnancy;
                            
                            system.debug('--Ques--'+objlead);
                            
                                      
                            
                            leadList.add(objlead);
      
                        
                    } else if(obj.form_url == 'https://anrclinic.com/opioid-withdrawal-treatment/'){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Opioid - Withdrawal Treatment').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Withdrawal Treatment';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/subutex-withdrawal/')){
                        
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/subutex-withdrawal').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Subutex Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/hydrocodone-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/hydrocodone-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Hydrocodone Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/methadone-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/methadone-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Methadone Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/vicodin-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/vicodin-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Vicodin Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/percocet-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/percocet-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Percocet Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/heroin-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/heroin-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Heroin Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/morphine-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/morphine-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Morphine Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/codeine-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/codeine-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Codeine Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/tramadol-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/tramadol-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Tramadol Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/tramadol-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/tramadol-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Tramadol Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/oxycodone-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/oxycodone-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Oxycodone Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/kratom-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/kratom-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Kratom Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/fentanyl-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/fentanyl-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Fentanyl Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-withdrawal-treatment/suboxone-withdrawal/')){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-Withdrawal Treatment/suboxone-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Suboxone Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    //Monday -17 Aug

                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opiate-schedule-a-consultation-1/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opiate-schedule-a-consultation-1').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Opiate Schedule a Consultation - 1';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            

                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opiate-schedule-a-consultation/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opiate-schedule-a-consultation').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Opiate Schedule a Consultation';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.How_can_we_help_you__c = obj.form_data.How_can_we_help_you;
                            
                            
                            leadList.add(objlead);
                            
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-schedule-a-consultation/')){
                        
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-schedule-a-consultation').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Opioid Schedule a Consultation';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                           
                            
                            leadList.add(objlead);
      
                        
                    } else if(obj.form_url.contains('https://anrclinic.com/opioid-schedule-a-consultation-1/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-schedule-a-consultation-1').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Opioid Schedule a Consultation - 1';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/narcotics-schedule-a-consultation/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('narcotics-schedule-a-consultation').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Narcotics Schedule a Consultation';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.How_can_we_help_you__c = obj.form_data.How_can_we_help_you;
                           
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/narcotics-schedule-a-consultation-1')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('narcotics-schedule-a-consultation-1').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Narcotics Schedule a Consultation -1';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/fight-opioid-with-medicine/')){
                        
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('fight-opioid-with-medicine').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Fight Opioid with Medicine';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.ParagraphText__c = obj.form_data.ParagraphText;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/fight-opioid-with-medicine-1/')){
                        
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('fight-opioid-with-medicine-1').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Fight Opioid with Medicine - 1';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.ParagraphText__c = obj.form_data.ParagraphText;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/heroin-schedule-a-consultation/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('heroin-schedule-a-consultation').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Heroin Schedule a Consultation';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.How_can_we_help_you__c = obj.form_data.How_can_we_help_you;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/heroin-schedule-a-consultation-1/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('heroin-schedule-a-consultation-1').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Heroin Schedule a Consultation - 1';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.How_can_we_help_you__c = obj.form_data.How_can_we_help_you;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/oxycodone-schedule-a-consultation/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('oxycodone-schedule-a-consultation').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Oxycodone Schedule a Consultation';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.How_can_we_help_you__c = obj.form_data.How_can_we_help_you;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/oxycodone-schedule-a-consultation-1/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('oxycodone-schedule-a-consultation-1').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Oxycodone Schedule a Consultation - 1';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.How_can_we_help_you__c = obj.form_data.How_can_we_help_you;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/subotex-schedule-a-consultation/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('subotex-schedule-a-consultation').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Subotex Schedule a Consultation';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.How_can_we_help_you__c = obj.form_data.How_can_we_help_you;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url.contains('https://anrclinic.com/subotex-schedule-a-consultation-1/')){
                            
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('subotex-schedule-a-consultation-1').getRecordTypeId();

                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Subotex Schedule a Consultation - 1';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.How_can_we_help_you__c = obj.form_data.How_can_we_help_you;
                            
                            
                            leadList.add(objlead);
                            
                    } else if(obj.form_url == 'https://anrclinic.com/opioid-withdrawal-treatment/opium-withdrawal/'){
                    
                            Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('opioid-withdrawal-treatment/opium-withdrawal').getRecordTypeId();

                        
                            Lead objLead = new Lead(RecordTypeId=recordTypeId);
                            objLead.LeadSource = 'Opium Withdrawal';
                            objLead.Status = 'New';
                            objLead.Id__c = obj.id;
                            objLead.Company_Id__c = obj.company_id;
                            objLead.Person_Id__c = obj.person_id;
                            objLead.Form_Url__c = obj.form_url;
                           objLead.Landing_Page_URL__c = obj.landing_page_url;
                           String str = obj.landing_page_url;
                            system.debug('gclid====' +str.substringAfter('gclid='));
                            system.debug('gclid='+obj.landing_page_url.substringAfter('gclid='));
                            objLead.GCLID__c =  str.substringAfter('gclid=');
                            objLead.Submitted_at__c = callrailHelper.getConvertDateTime(obj.submitted_at);
                            objLead.Referrer__c = obj.referrer;
                            objLead.Referring_URL__c = obj.referring_url;
                            objLead.First_Form__c = obj.first_form;
                            objLead.Customer_Phone_Number__c = obj.customer_phone_number;
                            objLead.Customer_Name__c = obj.customer_name;
                            objLead.Formatted_Customer_Phone_Number__c = obj.formatted_customer_phone_number;
                            objLead.Formatted_Customer_Name__c = obj.formatted_customer_name;
                            objLead.Source__c = obj.source;
                            objLead.keywords__c = obj.keywords;
                            objLead.Campaign__c = obj.campaign;
                            objLead.Medium__c = obj.medium;
                            
                            if(obj.form_data.FirstName != null && obj.form_data.LastName != null){
                            
                                objLead.FirstName = obj.form_data.FirstName;
                            
                                objLead.LastName = obj.form_data.LastName;
                            
                            } else {
                            
                                objLead = callrailHelper.GetFirstandLastName(objLead,obj.form_data.name);
                            }
                            
                            objLead.Email = obj.form_data.Email;
                            objLead.Phone = obj.form_data.Phone;
                            objLead.Message__c = obj.form_data.Message;
                            
                            
                            leadList.add(objlead);
                            
                    }     
                    
                    
                    
                    
                }
                
                if(!leadList.isEmpty()){
                    Database.UpsertResult[] results = Database.upsert(leadList, Lead.Id__c,false);
                    for(Integer index = 0, size = results.size(); index < size; index++) {
                        if(results[index].isSuccess()) {
                            if(results[index].isCreated()) {
                                System.debug(leadList[index].Id__c +' was created');
                            } else {
                                System.debug(leadList[index].Id__c +' was updated');
                            }
                        } else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : results[index].getErrors()) {
                                System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                System.debug('fields that affected this error: ' + err.getFields());
                                
                            }
                        }
                    }
                }
                    
                      
            } else {
                check = false;
            } 
                                    
                  
                           
          }
          catch (Exception e) {         
            System.debug('Error:' + e.getMessage() + 'Line Number:   ' + e.getLineNumber() );   
            
            
             check = false;
      
          }
       
    }   

    global void finish(Database.BatchableContext BC){  
    
        if(check){
            
            if(pageNumber < numberOfPages){
                
                pageNumber = pageNumber+1;
            
                Database.executeBatch(new BatchforcallrailFormSubmissions(check7Days,check,pageNumber,pageSize));

            } 
        }  
        
    }
}