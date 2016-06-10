local LED_PIN1 = 4  
 gpio.mode(LED_PIN1, gpio.OUTPUT)  
 local sw1 = true  
 wifi.setmode(wifi.SOFTAP)  
 cfg={}  
    cfg.ssid="EvolutLight"  
    wifi.ap.config(cfg)  
	
 err=0  
 cold=1  
 
 s=net.createServer(net.UDP)   
 s:on("receive",function(s,c)  
   print("Sequence="..c.." Previous:"..cold)  
 if ((cold+1)~=tonumber(c)) then  
   err=err+1  
   end  
   
     if (sw1) then  
       gpio.write(LED_PIN1, gpio.LOW)  
     else  
       gpio.write(LED_PIN1, gpio.HIGH)  
     end  
   sw1 = not sw1  
 cold=c  
 end)   
 s:listen(8888)  