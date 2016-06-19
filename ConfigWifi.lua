	local function configWifi()
    	
    	if range ==1 then 
    		--InitWifi()
    		InitMaster()
    	    CheckStation()

          StartListenerUdp=nil
          TryConnectToAP=nil
          CheckConnToAP=nil
		  parseArgs=nil
		  uri_decode=nil

         
    	elseif range==2 then 
    		wifi.setmode(wifi.STATION)   
            
            wifi.sta.config("EvolutLight","")  
            TryConnectToAP()
            CheckConnToAP() 
            
    		--CheckStation()
    	else 	
    		print("ERROR RANGE WIFI NON CONFIGURE")
    	end
     end

    configWifi()
   
     
	
	
			
