public class callrailHelper{

  public static string getcallrailCallJSON(boolean check7Days,string pageNumber,string pageSize){
    
     String accountId = Label.CallRailAccountId;
     String apiKey = Label.CallRailAPIKey;
     
     HttpRequest req = new HttpRequest();  
     
     req.setMethod('GET');  
     string endPoint = 'https://api.callrail.com/v3/a/'+accountId+'/calls.json?page='+pageNumber+'&per_page='+pageSize;
     
     if(check7Days){
     
         endPoint = 'https://api.callrail.com/v3/a/'+accountId+'/calls.json?page='+pageNumber+'&per_page='+pageSize+'&date_range=last_7_days';
     }
     
     req.setEndpoint(endPoint);
     String authorizationHeader = 'Token token="'+apiKey+'"';
     req.setHeader('Authorization', authorizationHeader);
     
     req.setTimeout(60*1000);  

     Http h = new Http();  

     String resp;  
     
     system.debug('req--'+req);
     
     
     HttpResponse res = new HttpResponse();
     
     if(Test.isRunningTest()){
         
         res.setBody(callrailCallJSON.testParse());
         res.setStatusCode(200);
         
     } else {
     
         res = h.send(req);  
     
     }
     
     resp = res.getBody();  
     
     System.debug(res.getBody());
     
     if(res.getBody() != null && res.getStatusCode()==200){  

      
        return res.getBody();

     }  

     return 'error';
    }
    
    
    public static string getcallrailFormSubmissionJSON(boolean check7Days,string pageNumber,string pageSize){
    
     String accountId = Label.CallRailAccountId;
     String apiKey = Label.CallRailAPIKey;
     
     HttpRequest req = new HttpRequest();  
     
     req.setMethod('GET');  
     string endPoint = 'https://api.callrail.com/v3/a/'+accountId+'/form_submissions.json?page='+pageNumber+'&per_page='+pageSize;
     
     //string endPoint = 'https://api.callrail.com/v3/a/'+accountId+'/form_submissions.json';
     
     if(check7Days){
     
         endPoint = 'https://api.callrail.com/v3/a/'+accountId+'/form_submissions.json?page='+pageNumber+'&per_page='+pageSize+'&date_range=last_7_days';
     }
     
     req.setEndpoint(endPoint);
     String authorizationHeader = 'Token token="'+apiKey+'"';
     req.setHeader('Authorization', authorizationHeader);
     
     req.setTimeout(60*1000);  

     Http h = new Http();  

     String resp;  
     
     system.debug('req--'+req);
     
     
     HttpResponse res = new HttpResponse();
     
     if(Test.isRunningTest()){
         
         res.setBody(callrailFormSubmissionJSON.testParse());
         res.setStatusCode(200);
         
     } else {
     
         res = h.send(req);  
     
     }
     
     resp = res.getBody();  
     
     System.debug(res.getBody());
     
     if(res.getBody() != null && res.getStatusCode()==200){  

      
        return res.getBody();

     }  

     return 'error';
    }
    
    public static DateTime getConvertDateTime(String dt){
        
        //2020-07-16T04:00:00Z
        
        if(dt !='' && dt != null){
            
            dt = dt.replace('Z','').replace('z','');
            
            List<String> dtimeList = dt.split('T');
            
            List<String> dateList = dtimeList[0].split('-');
            List<String> timeList = dtimeList[1].split(':');
            
            
            Datetime dTime = Datetime.newInstance(integer.valueOf(dateList[0]), integer.valueOf(dateList[1]), integer.valueOf(dateList[2]), integer.valueOf(timeList[0]), integer.valueOf(timeList[1]),0);
            
            return dTime;
        }
        
        return null;
        
    }
    
    public static Date getConvertDate(String dt){
        
        //2020-07-16T04:00:00Z
        
        if(dt !='' && dt != null){
            
            dt = dt.replace('Z','').replace('z','');
            
            
            List<String> dateList = dt.split('/');
                        
            Date dnew = Date.newInstance(integer.valueOf(dateList[2]),integer.valueOf(dateList[0]), integer.valueOf(dateList[1]));
            
            return dnew;
        }
        
        return null;
        
    }
    
    public static Lead GetFirstandLastName(Lead objLead,String fullName){
        
        String firstName;
        String lastName;
        
        if(fullName.contains(' ')){
            
            firstName = fullName.Substring(0, fullName.IndexOf(' '));
            lastName = fullName.Substring(fullName.IndexOf(' ') + 1);
        
        } else {
            firstName = fullName;
        }
        
        
        if(lastName != null && lastName !=''){
            
            objLead.FirstName = firstName;
            objLead.LastName = lastName;
            
        } else {
            
            objLead.LastName = firstName;
            
        }
        
        return objLead;
        

    }  
}