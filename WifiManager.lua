 LED_PIN0 = 0  
 gpio.mode(LED_PIN0, gpio.OUTPUT)  
 previousCheck=0
 previousTry=0
 firstCo=0
 previousColor=0
 Color=168
 
	 local function StartListenerUdp()
		 s=net.createServer(net.UDP)   
         print(s)
		 s:on("receive",function(s,c)  
			print("Recu Color="..c.." Previous:"..previousColor)  
			
			--gpio.write(LED_PIN0, gpio.LOW)  
			--gpio.write(LED_PIN0, gpio.HIGH)  
			  
			previousColor=c  
		 end)   
		 s:listen(8888) 
	end
	
	function CheckStation()
        tmps=tmr.now()/1000000
        tmps=tmps-tmps%1
		--print("Les stations sont :")
		for mac,ip in pairs(wifi.ap.getclient()) do
			print(mac,ip)

            for k, v in ipairs(allvalues) do
                
                if v.staMAC == mac then
                    if(allvalues[k].conn==nil)then
                        --print("Connection")
                        allvalues[k].conn = net.createConnection(net.UDP, 0)
                        print(allvalues[k].conn)
                        allvalues[k].conn:connect(8888,ip)  

                        print("CONNECTION DU NODE "..k) 
                        allvalues[k].vu=tmps
                    else
                        --print("SendUDP")
                        --if(previousColor~=Color)then
                            Color=tmps
                            allvalues[k].conn:send(Color)  
                            
                            print("Node "..k.." Color sent with value:"..Color)
                    
                            previousColor=Color
                        --  else
                        --      print("SendUDP: Rien a envoyer"..tmr.now()/1000000)
                        --  end
                        allvalues[k].vu=tmps
                    end--if conn
                end--if mac
            end-- for allchip
		end
     
        for k, v in ipairs(allvalues) do
            if allvalues[k].conn ~= nil then
                if allvalues[k].vu ~= tmps then
                    allvalues[k].conn:close()  
                    allvalues[k].conn = nil
                    print("DECONNECTION DU NODE "..k) 
                end
            end                    
        end
        if range > 1 then
		    tmr.alarm(3, 5000, tmr.ALARM_SINGLE, CheckStation)--tmr,temps,mode,fct
        end
	end
	

	
	function TryConnectToAP()
		tmp=tmr.now()/1000000
	    --print("TryConnectToAP")
	    p=wifi.sta.status()
	    --print ("Wifi status :"..p)  
	    p=tonumber(p)
	    --if p == 1 then --STA_CONNECTING
		--	print("Connection en ATTENTE "..tmp.."s")
		--	tmr.alarm(4, 5000, tmr.ALARM_SINGLE, TryConnectToAP)--tmr,temps,mode,fct
		--else
		if p ~= 5 then -- pas connecte 
			--print("Connection OFF "..tmp.."s")
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

    function CheckConnToAP()
        tmp=tmr.now()/1000000
        --print("CheckConnexion")
        p=wifi.sta.status()
        --print ("Wifi status :"..p)  
        p=tonumber(p)
        if p == 5 then --Connection etablie 
            if(previousCheck~=5)then
                print("Connection ON "..tmp.."s")
                StartListenerUdp()
            end
            previousCheck=5
            tmr.alarm(5,10000, tmr.ALARM_SINGLE, CheckConnToAP)
        else  
           
            if firstCo==0 then
                print("Connection OFF "..tmp.."s")
                print("Activation de la boucle de scrutation à 100ms ")
                firstCo=1
                gpio.write(LED_PIN0, gpio.HIGH)
            end
            if(previousCheck==5)then
                print("Connection OFF "..tmp.."s")
                previousCheck=0
                gpio.write(LED_PIN0, gpio.HIGH)  
                --print ("LED ON") 
            
                print("Close Server")
               s:close()
               TryConnectToAP()
            end
            
            ----wifi.setmode(wifi.STATION)  
            ----wifi.sta.config("EvolutLight","")  
            --wifi.sta.connect()  
            tmr.alarm(5, 100, tmr.ALARM_SINGLE, CheckConnToAP)--tmr,temps,mode,fct
        end  
        --print("Fin du check")
    end
