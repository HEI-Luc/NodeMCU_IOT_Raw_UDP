local LED_PIN0 = 0
 gpio.mode(LED_PIN0, gpio.OUTPUT)  
 
 

 wifi.setmode(wifi.SOFTAP)  
 cfg={}  
    cfg.ssid="EvolutLight"  
    wifi.ap.config(cfg)  
	
 previousColor=1  
 
 s=net.createServer(net.UDP)   
 s:on("receive",function(s,c)  
   print("Color="..c.." Previous:"..previousColor)  
    
    
       --gpio.write(LED_PIN0, gpio.LOW)  
     
       --gpio.write(LED_PIN0, gpio.HIGH)  
    
  
 previousColor=c  
 end)   
 s:listen(8888)  
 
