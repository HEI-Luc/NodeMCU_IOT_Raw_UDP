	local function configWifi()
    	
    	if range ==1 then -- master AP
    		--wifi.setmode(wifi.SOFTAP) 
    
    		--cfg={}  
    		--cfg.ssid="EvolutLight"  
    		--wifi.ap.config(cfg)  
    				
    		--print ("Le point d'acces qui emet est "..cfg.ssid)
    		InitWifi()
    		InitMaster()
    		CheckStation()
    	elseif range==2 then 
    		wifi.setmode(wifi.STATIONAP )  
    		cfg={}  
    		cfg.ssid="EvolutLight2"  
    		wifi.ap.config(cfg)				
    		print ("Le point d'acces qui emet est "..cfg.ssid)  
    
            
            wifi.sta.config("EvolutLight","")  
            TryConnectToAP()
            CheckConnToAP() 
            
    		CheckStation()
    	elseif range==3 then 
    		wifi.setmode(wifi.STATIONAP )  
    		cfg={}  
    		cfg.ssid="EvolutLight3"  
    		wifi.ap.config(cfg)				
    		print ("Le point d'acces qui emet est "..cfg.ssid)
    
            wifi.sta.config("EvolutLight","")  
            TryConnectToAP() 
            CheckConnToAP()
            
    		CheckStation()
    	elseif range==4 then --Seul les niveau 4 et 5 sont seulement STATION
    		wifi.setmode(wifi.STATION)  
    		wifi.sta.config("EvolutLight2","")  
            
    		TryConnectToAP()
    		CheckConnToAP()	
    	 elseif range==5 then --Seul les niveau 4 et 5 sont seulement STATION
    		wifi.setmode(wifi.STATION)  
    		wifi.sta.config("EvolutLight3","")  
            
    		TryConnectToAP()
    		CheckConnToAP()
    	else 	
    		print("ERROR RANGE WIFI NON CONFIGURE")
    	end
     end

    configWifi()
     
	
	
			
