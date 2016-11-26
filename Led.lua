
    NB_LED     = 144                --Nb de led chainées

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
        
		if ActivationScenario==1 then
			Obj_G=D_led	
			Obj_R=D_led	
			Obj_B=D_led	
			Obj_W=D_led	
			
		elseif allvalues[nodeId].OFF==1 then 
			print("Statut off : ",allvalues[nodeId].OFF)
			Obj_G=0	
			Obj_R=0	
			Obj_B=0	
			Obj_W=0
		else	
			Obj_G = allvalues[nodeId].G 
			Obj_R = allvalues[nodeId].R 
			Obj_B = allvalues[nodeId].B 
			Obj_W = allvalues[nodeId].W 
		end
		
		if Obj_G ~= G then G=smooth(Obj_G,G) end
		if Obj_R ~= R then R=smooth(Obj_R,R) end
		if Obj_B ~= B then B=smooth(Obj_B,B) end
		if Obj_W ~= W then W=smooth(Obj_W,W) end
		
		LedColor  = string.char(G,R,B,W)
		--LedColor2 = string.char(G,R,B)
		LedColor2 = string.char(G,R,B,W)
		
	--	if nodeId ==1 then
	--		ws2812.write(string.rep(LedColor,20)..string.rep(LedColor2,20))
	--	else
			ws2812.write(string.rep(LedColor2,NB_LED))
	--	end
		--string.char(255,255,255,255)
		--ws2812.write(string.rep(string.char(255,255,255,255),NB_LED))
        
		LedColor=nil
		--print("ledOK")
    end

	
	
	
	
	
	
	Obj_led = 70
	D_led = 70
	SEUIL = 64
	--NB_LED=35 voir plus haut
	Objectif = 0
	Renversement =0
	
	function DemarrageScenario()
		if ActivationScenario ==0 then
			if allvalues[nodeId].G > D_led then D_led=allvalues[nodeId].G end
			if allvalues[nodeId].R > D_led then D_led=allvalues[nodeId].R end
			if allvalues[nodeId].B > D_led then D_led=allvalues[nodeId].B end
			P_led=D_led
			Obj_led=D_led
		end
		ActivationScenario=1;
	end
    function ArretScenario()
		print("Arret scenario")
		ActivationScenario=0
		sens=nil
		LedRefresh()
	end
	function Scenario () 
		if P_led == Obj_led then 
			if Obj_led == D_led then
				if D_led >SEUIL then
					sens=0
					Obj_led=D_led/2
					Objectif = 1
					print("moitie")
				else
					sens=1
					Obj_led=D_led+20
					Objectif = 1
					print("+20")
				end
			else
				Obj_led=D_led					
				print("Demande")
			end
			print("Nouvel Objectif",P_led, Obj_led , D_led)
			LedRefresh()
		end
	end
	
	
	function capteur ()
	
		if gpio.read(5) == 1 then
			gpio.write(0, gpio.HIGH) -- stable
			
	
				if Renversement ==0 then
					print("Renversement dedecte")
					Renversement=1
					DemarrageScenario()
					tmr.alarm(2, 1000, tmr.ALARM_SINGLE, ArretScenario)--tmr,temps,mode,fct
				end
		--	end
		else
			gpio.write(0, gpio.LOW)
						
			if Renversement==1 then
				print("Fin du renversement")
				Renversement=0
				DemarrageScenario()
				tmr.alarm(2, 1000, tmr.ALARM_SINGLE, ArretScenario)--tmr,temps,mode,fct
			end
		end
		
		Scenario()
		 
		tmr.alarm(6, 30, tmr.ALARM_SINGLE, capteur)--tmr,temps,mode,fct
	end
    
	
	gpio.mode(5, gpio.INPUT, gpio.PULLUP)
	capteur()