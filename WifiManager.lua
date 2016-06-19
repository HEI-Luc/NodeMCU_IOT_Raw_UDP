 LED_PIN0 = 0  
 gpio.mode(LED_PIN0, gpio.OUTPUT)  
 previousCheck=0
 previousTry=0
 firstCo=0
 previousColor=0
 Color=168
	
	
	local function parseArgs(args) -- parse quoi ?
		--print("parseArgs",node.heap())
	   local r = {}; i=1
	   if args == nil or args == "" then return r end--chaine vide
		repeat
			--print(args)
			pos=args:find("=")
			if pos then
				name=args:sub(0,pos-1)
				--print(name)
				if name ~= nil then
					posVal=args:find("&")
					if posVal then
						value=args:sub(pos+1,posVal-1)
						args=args:sub(posVal+1,#args)
						r[name] = tonumber(value)
						i = i + 1
					else
						value=args:sub(pos+1,#args)
						r[name] = tonumber(value)
						i = i + 1
						name=nil
					end
					--print(value)
				end	
			end
		until name == nil
	   return r
	end


	 local function StartListenerUdp()
		 s=net.createServer(net.UDP)   
         print(s)
		 s:on("receive",function(s,msg)  
			print("Recu Color="..msg.." Previous:"..previousColor)  
			
			questionMarkPos, b, c, d, e, f = msg:find("?")
		   if questionMarkPos then
			  tab=parseArgs(msg:sub(questionMarkPos+1, #msg))
		   end
			
			--print("le tableau est")
			--parseArgs(c)
			for name, value in pairs(tab) do
			--	print("Recu: ",name,"=",value)
			
				if name == "R" then 
					if allvalues[nodeId].R ~= value then
						print("Old: ",Gvalue," New: ",value)
						allvalues[nodeId].R=value
						updated=1
					end
				elseif name == "G" then 
					if allvalues[nodeId].G ~= value then
						print("Old: ",Gvalue," New: ",value)
						allvalues[nodeId].G=value
						updated=1
					end
				elseif name == "B" then 
					if allvalues[nodeId].B ~= value then
						print("Old: ",Gvalue," New: ",value)
						allvalues[nodeId].B=value
						updated=1
					end
				elseif name == "W" then 
					if allvalues[nodeId].W ~= value then
						print("Old: ",allvalues[nodeId].W," New: ",value)
						allvalues[nodeId].W=value
						updated=1
					end
				elseif name == "OFF" then 
					if allvalues[nodeId].OFF ~= value then
						print("Old: ",allvalues[nodeId].OFF," New: ",value)
						allvalues[nodeId].OFF=value
						updated=1
					end
				else
				
				end
				
	--			for Gname, Gvalue in pairs(allvalues[nodeId]) do
	--			--	--print("Global: ",name,"=",value)
	--				if name==Gname then
	--					if Gvalue ~= value then
	--						print("Global: ",name,"=",value)
	--						print("Old: ",Gvalue," New: ",value)
	--						allvalues[nodeId].R=value
	--						
	--						updated=1
	--					end
	--				end
	--			end
			end
			  
			previousColor=msg  
			if updated then
				--print("GoRefresh")
				LedRefresh()
				updated=nil
			end
		 end)   
		 s:listen(8888) 
	end
	
	function CheckStation()
        tmps=tmr.now()/1000000
        
		--print("Les stations sont :")
		for mac,ip in pairs(wifi.ap.getclient()) do
			

            for k, v in ipairs(allvalues) do
                
                if v.staMAC == mac then
                    if(allvalues[k].conn==nil)then
                        --print("Connection")
                        allvalues[k].conn = net.createConnection(net.UDP, 0)
                        print(allvalues[k].conn)
                        allvalues[k].conn:connect(8888,ip)  

                        print("CONNECTION DU NODE "..k) 
						allvalues[k].NewValue =1
                    else
                        --print("SendUDP")
                        if(allvalues[k].NewValue ==1)then
                            
							
                            allvalues[k].conn:send("?W="..allvalues[k].W.."&R="..allvalues[k].R.."&G="..allvalues[k].G.."&B="..allvalues[k].B.."&OFF="..allvalues[k].OFF)  
                            
                            print("Node "..k.." Colors sent")
							
							allvalues[k].NewValue =0
                            previousColor=Color
                        --  else
                        --      print("SendUDP: Rien a envoyer"..tmr.now()/1000000)
                        end
                    end--if conn
					allvalues[k].vu=tmps
				else
				
					if not OtherMac then
						print(mac,ip)
						OtherMac = mac
					elseif OtherMac ~= mac then
						print(mac,ip)
						OtherMac = mac
					end			
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
        elseif not connectionThread then
			tmr.alarm(3, 10000, tmr.ALARM_SINGLE, CheckStation)--tmr,temps,mode,fct
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
