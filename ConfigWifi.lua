	
	
	if range ==1 then -- master AP
		wifi.setmode(wifi.SOFTAP) 

		cfg={}  
		cfg.ssid="EvolutLight"  
		wifi.ap.config(cfg)  
				
		print ("Le point d'acces qui emet est "..cfg.ssid)  
		CheckStation()
	elseif range==2 then 
		wifi.setmode(wifi.STATIONAP )  
		cfg={}  
		cfg.ssid="EvolutLight2"  
		wifi.ap.config(cfg)  
				
		print ("Le point d'acces qui emet est "..cfg.ssid)  
		CheckStation()
	elseif range==3 then 
		wifi.setmode(wifi.STATIONAP )  
		cfg={}  
		cfg.ssid="EvolutLight3"  
		wifi.ap.config(cfg)  
				
		print ("Le point d'acces qui emet est "..cfg.ssid)  
		CheckStation()
	elseif range==4 --Seul les niveau 4 et 5 sont seulement STATION
		wifi.setmode(wifi.STATION)  
		wifi.sta.config("EvolutLight2","")  
		wifi.sta.connect()

		CheckConnToAP()	
	 elseif range==5 --Seul les niveau 4 et 5 sont seulement STATION
		wifi.setmode(wifi.STATION)  
		wifi.sta.config("EvolutLight3","")  
		wifi.sta.connect() 
			
		CheckConnToAP()
	else 	
		print("ERROR RANGE WIFI NON CONFIGURE")
	end
	
	
			
