
    NB_LED     = 25                 --Nb de led chainées

   

   -- LedColor=string.char(0,0,0,0)
   --zero = 25 
	
	function smooth(O_led,P_led)
		--print("smooth ",O_led,P_led )
		
		if P_led < O_led then
			if P_led+20 < O_led then
				P_led = P_led +10
			else
				P_led = P_led +1
			end
			tmr.alarm(1, 30, tmr.ALARM_SINGLE, LedRefresh)--tmr,temps,mode,fct
		elseif P_led > O_led then
			if P_led-20 > O_led then
				P_led = P_led -10
			else
				P_led = P_led -1
			end
			tmr.alarm(1, 30, tmr.ALARM_SINGLE, LedRefresh)--tmr,temps,mode,fct
		else
			--print("Objectif atteint")
		end
		--print(P_led)
		return P_led
	end
	
    function LedRefresh()
		
		if not INIT then 
			--print("Init Led")
			ws2812.init()
			INIT=1
			
			G = allvalues[nodeId].G 
			R = allvalues[nodeId].R 
			B = allvalues[nodeId].B 
			W = allvalues[nodeId].W 
		end
	
        --print("refresh led")
        
		if allvalues[nodeId].OFF==1 then 
			print("Statut off : ",allvalues[nodeId].OFF)
			if 0 ~= G then G=smooth(0,G) end
			if 0 ~= R then R=smooth(0,R) end
			if 0 ~= B then B=smooth(0,B) end
			if 0 ~= W then W=smooth(0,W) end
		else
			if allvalues[nodeId].G ~= G then G=smooth(allvalues[nodeId].G,G) end
			if allvalues[nodeId].R ~= R then R=smooth(allvalues[nodeId].R,R) end
			if allvalues[nodeId].B ~= B then B=smooth(allvalues[nodeId].B,B) end
			if allvalues[nodeId].W ~= W then W=smooth(allvalues[nodeId].W,W) end
		end
		
		LedColor  = string.char(G,R,B,W)
		--LedColor2 = string.char(G,R,B)
		LedColor2 = string.char(G,R,B,0)
		ws2812.write(string.rep(LedColor,12)..string.rep(LedColor2,35))
		
		--string.char(255,255,255,255)
		--ws2812.write(string.rep(string.char(255,255,255,255),NB_LED))
        
		LedColor=nil
		--print("ledOK")
    end

    
    
