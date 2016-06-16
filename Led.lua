
    NB_LED     = 25                 --Nb de led chainées

    ws2812.init()

   -- LedColor=string.char(0,0,0,0)

    function LedRefresh()
        print("refresh led")
        
		LedColor = string.char(allvalues[nodeId].G,allvalues[nodeId].R,allvalues[nodeId].B,allvalues[nodeId].W)
		ws2812.write(string.rep(LedColor,NB_LED))
        
		LedColor=nil
        --tmr.alarm(1, 1000, tmr.ALARM_SINGLE, LedRefresh)--tmr,temps,mode,fct
    end

    
    