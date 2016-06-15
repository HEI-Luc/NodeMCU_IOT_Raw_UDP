
	local function CompileFile(exefile)
        print("Compile if need "..exefile.." "..node.heap())
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
		end
     exefile=nil
	end
 
    local function DoFiles(exefile)
        if gpio.read(1) == 1 then
            if file.open(exefile..".lc") then
                --print(exefile..".lc non voulu")
                dofile(exefile..".lc")
            else
                print(exefile..".lc not exist")
            end
            collectgarbage()
            print("Heap ",node.heap()) 
        end
        exefile=nil
    end

     
    local httpFiles = {
       'args.lua',
       'file_list.lua',
       'node_info.lua',
       'Rainbow.lua',
       'post.lua',   
       'index.html',  
       'White.html',  
       'Style.css',  
       'range.html', 
       'range2.htm', 
       'range2.html',
       'favicon.ico',
       'favicon.gif',
       'RGB.svg',
       'RGB.png',
       'apple-touch-icon.png',
    }
    
    local function RenameHttp(f)       
         if file.open(f) then
          file.close()
          if file.open('http/'..f) then
             file.close()
             file.remove('http/'..f)
          end
          print('Rename http/', f)
          file.rename(f,"http/"..f)
          file.remove(f)
          collectgarbage()
       end
    end

     for i, f in ipairs(httpFiles) do RenameHttp(f) end
     RenameHttp = nil
     httpFiles = nil
     collectgarbage()
 
    
    local serverFiles = {
       'httpserver',
       'httpserver-b64decode',
       'httpserver-basicauth',
       'httpserver-conf',
       'httpserver-connection',
       'httpserver-error',
       'httpserver-header',
       'httpserver-request',
       'httpserver-static',
    }

    for i, f in ipairs(serverFiles) do 
        CompileFile(f);
    end
   
   
    serverFiles = nil
    collectgarbage()
	
		
	local ToCompileFiles = {
	   'ChipManager',
	   'Master',
	   'WifiManager',
	   'ConfigWifi',
	   'httpserver',
       'Led',
	}

	local ToDoFiles = {
	   'ChipManager',
	   'Master',
	   'WifiManager',
	   'ConfigWifi',
       'Led',
	}

	for i, f in ipairs(ToCompileFiles) do 
		CompileFile(f);
	end
	ToCompileFiles = nil  
	CompileFile=nil

	for i, f in ipairs(ToDoFiles) do 
		DoFiles(f);
	end
	ToCompileFiles = nil  
	DoFile=nil

	configWifi=nil
