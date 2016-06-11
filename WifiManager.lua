 LED_PIN0 = 0  
 gpio.mode(LED_PIN0, gpio.OUTPUT)  
 previousConnexion=0
 previousColor=0
 Color=168
 
 delaySend=10
	 
dix=0
	function StartListenerUdp()
		 s=net.createServer(net.UDP)   
		 s:on("receive",function(s,c)  
			print("Color="..c.." Previous:"..previousColor)  
			
			--gpio.write(LED_PIN0, gpio.LOW)  
			--gpio.write(LED_PIN0, gpio.HIGH)  
			  
			previousColor=c  
		 end)   
		 s:listen(8888) 
	end
	
	function CheckStation()
		print("Les stations sont :")
		for mac,ip in pairs(wifi.ap.getclient()) do
			print(mac,ip)
			
			if(mac=="18:fe:34:d6:7f:1d")then
				if(dix==0)then
					print("Connection")
					conn = net.createConnection(net.UDP, 0)
					print(conn)
					conn:connect(8888,ip)  
					
					--conn:close()  
					--conn = nil 
					dix=conn
				else
					print("SendUDP")
					--if(previousColor~=Color)then
					
					Color=tmr.now()/1000000
					conn:send(Color)  
					
					print("Color sent with value:"..Color)
			
					previousColor=Color
						
					--	else
					--		print("SendUDP: Rien a envoyer"..tmr.now()/1000000)
					--	end
				end
			end
		end
		tmr.alarm(3, 5000, tmr.ALARM_SINGLE, CheckStation)--tmr,temps,mode,fct
	end
	
	function CheckConnToAP()
		tmp=tmr.now()/1000000
	    --print("CheckConnexion")
	    p=wifi.sta.status()
	    --print ("Wifi status :"..p)  
	    p=tonumber(p)
	    if p == 5 then --Connection etablie 
			
			if(previousConnexion~=5)then
				print("Connection ON "..tmp.."s")
				StartListenerUdp()
			end
			previousConnexion=5
			tmr.alarm(3,10000, tmr.ALARM_SINGLE, CheckConnexion)
		else  
			print("Connection OFF "..tmp.."s")
			previousConnexion=p
			gpio.write(LED_PIN0, gpio.HIGH)  
			--print ("LED ON") 

            if(previousConnexion==5)then
                print("Close Server")
               s:close()
			   TryConnectToAP()
            end
            
			----wifi.setmode(wifi.STATION)  
			----wifi.sta.config("EvolutLight","")  
			--wifi.sta.connect()  
			tmr.alarm(3, 100, tmr.ALARM_SINGLE, CheckConnexion)--tmr,temps,mode,fct
		end  
		
		--print("Fin du check")
	end
	
	function TryConnectToAP()
		tmp=tmr.now()/1000000
	    --print("TryConnectToAP")
	    p=wifi.sta.status()
	    --print ("Wifi status :"..p)  
	    p=tonumber(p)
	    if p == 1 then --STA_CONNECTING
			print("Connection en ATTENTE "..tmp.."s")
			tmr.alarm(4, 5000, tmr.ALARM_SINGLE, TryConnectToAP)--tmr,temps,mode,fct
		else if ~=5 then -- pas connecte 
			print("Connection OFF "..tmp.."s")
			previousConnexion=p
			gpio.write(LED_PIN0, gpio.HIGH)  
			--print ("LED ON") 

			----wifi.setmode(wifi.STATION)  
			----wifi.sta.config("EvolutLight","")  
			wifi.sta.connect()  
			tmr.alarm(4, 5000, tmr.ALARM_SINGLE, TryConnectToAP)--tmr,temps,mode,fct
		end  
		-- sinon on re rappelle pas la fct
		
		--print("Fin du check")
	end