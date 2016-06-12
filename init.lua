--for n,s in pairs(file.list()) do file.remove(n) end

	function CompileFile()
		if file.open(exefile..".lua") then
			file.close()
			
			if file.open(exefile..".lc") then
			  file.close()
			  file.remove(exefile..".lc")
			end
		
			print("Compile File:"..f)
			node.compile(f)
			print("Remove File:"..f)
			file.remove(f)
		  --dofile(exefile..".lc")
		end
	end

uart.setup(0,115200,8,0,1,0)

print("Baud Rate set to 115200 by DDrmx")

print("\n")
print("NodeMCU Started")

exefile= "ChipManager"
CompileFile();
exefile= "Master"
CompileFile();
exefile= "ConfigWifi"
CompileFile();


	gpio.mode(1, gpio.INPUT, gpio.PULLUP)
	if gpio.read(1) == 1 then
		exefile= "ChipManager"
		if file.open(exefile..".lc") then
			--print(exefile..".lc non voulu")
			dofile(exefile..".lc")
		else
			print(exefile..".lc not exist")
		end
		
		exefile= "Master"
		if file.open(exefile..".lc") then
			--print(exefile..".lc non voulu")
			dofile(exefile..".lc")
		else
			print(exefile..".lc not exist")
		end
		exefile= "ConfigWifi"
		if file.open(exefile..".lc") then
			--print(exefile..".lc non voulu")
			dofile(exefile..".lc")
		else
			print(exefile..".lc not exist")
		end
	end

exefile=nil;

print("Fin de l'init")
collectgarbage()
