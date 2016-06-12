--for n,s in pairs(file.list()) do file.remove(n) end

	local function CompileFile()
		if file.open(exefile..".lua") then
			file.close()
			
			if file.open(exefile..".lc") then
			  file.close()
			  file.remove(exefile..".lc")
			end
		
			print("Compile File:"..exefile)
			node.compile(exefile..".lua")
			print("Remove File:"..exefile..".lua")
			file.remove(exefile..".lua")
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
exefile= "WifiManager"
CompileFile();
exefile= "ConfigWifi"
CompileFile();
exefile= "httpserver"
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
       exefile= "WifiManager"
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
