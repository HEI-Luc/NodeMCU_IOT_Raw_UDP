
 LED_PIN0 = 0  
 gpio.mode(LED_PIN0, gpio.OUTPUT)  
 previousConnexion=0
 previousColor=0
 Color=168
 
 delaySend=10
	 
	 function SendUdp()  
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
   
   
   
   
   function CheckConnexion()
		print("CheckConnexion")
	   p=tonumber(wifi.sta.status())
	   print ("Wifi status :"..p)  
	   if p == 5 then  
			
			if(previousConnexion~=5)then
				
				print ("La connection est etablie "..wifi.sta.getip())  
				gpio.write(LED_PIN0, gpio.LOW)  
				print ("LED OFF")
				
				previousConnexion=5
				conn = net.createConnection(net.UDP, 0)
				print(conn)
				conn:connect(8888,"192.168.4.1")  
				
				--conn:close()  
				--conn = nil 
			
			end
			SendUdp()
			print("Retour1")
			tmr.alarm(3, delaySend, tmr.ALARM_SINGLE, CheckConnexion)--tmr,temps,mode,fct
			print("Call timer: prochain appel dans: "..delaySend)
		else  
			print("Connection OFF")
			previousConnexion=p
			gpio.write(LED_PIN0, gpio.HIGH)  
			print ("LED ON") 
			
			wifi.setmode(wifi.STATION)  
			wifi.sta.config("EvolutLight","")  
			wifi.sta.connect()  
			tmr.alarm(3, 5000, tmr.ALARM_SINGLE, CheckConnexion)--tmr,temps,mode,fct
		end  
		print("Fin du check")
	end

print("Premier Appel")
CheckConnexion() -- Premier appel de la fct