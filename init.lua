--for n,s in pairs(file.list()) do file.remove(n) end

uart.setup(0,115200,8,0,1,0)

print("Heap",node.heap())
print("Baud Rate set to 115200 by DDrmx")
print("\n")
print("NodeMCU Started")

	gpio.mode(1, gpio.INPUT, gpio.PULLUP)
	if gpio.read(1) == 1 then
		if file.open("RealInit.lua") then
			file.close()
			if file.open("RealInit.lc") then
				file.close()
				file.remove("RealInit.lc")
            end
			node.compile("RealInit.lua")
			file.remove("RealInit.lua")
			print("Fin de compile de RealInit")
			print("Restart")
			node.restart()
		else
			if file.open("RealInit.lc") then
				file.close()
                dofile("RealInit.lc")
			else
				print("RealInit.lua manquant")
			end
		end 
	end

print("Fin de l'init")
collectgarbage()
