
 LED_PIN1 = 4  
 gpio.mode(LED_PIN1, gpio.OUTPUT)  
 x=1  
 
 
 tmr.alarm(2, 1000, 1, function()  
 
   conn = net.createConnection(net.UDP, 0)  
   conn:connect(8888,"192.168.4.1")  
   conn:send(x)  
   conn:close()  
   conn = nil  
   x=x+1  
   print (x)  
   if x>1000 then x=1 end  
   
   p=tonumber(wifi.sta.status())  
   print (p)  
    if p == 5  
		then  
		gpio.write(LED_PIN1, gpio.LOW)  
		print ("LED OFF")  
		else  
		gpio.write(LED_PIN1, gpio.HIGH)  
		print ("LED ON") 
	else
		wifi.setmode(wifi.STATION)  
		wifi.sta.config("EvolutLight","")  
		wifi.sta.connect()  
		print (wifi.sta.getip())  
    end  
 end)  