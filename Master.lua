function InitWifi()
    
    print("InitWifi")
    
    if file.open("Config_Wifi.txt", "r") then
        str = file.readline()
        file.close()
        SSID = string.sub(str,1,string.find(str, ":")-1)
        PWD = string.sub(str,string.find(str, ":")+1,string.find(str, ";")-1) 
        
        str = nil
        
        print(SSID)
        print (PWD)
        
        
    else
        print("Config_Wifi.txt not exist")
    end
end
                    
function InitMaster()
    
    -- Begin WiFi configuration
    
    local wifiConfig = {}
    
    -- wifi.STATION         -- station: join a WiFi network
    -- wifi.SOFTAP          -- access point: create a WiFi network
    -- wifi.wifi.STATIONAP  -- both station and access point
    wifiConfig.mode = wifi.STATIONAP  -- both station and access point
    
    wifiConfig.accessPointConfig = {}
    wifiConfig.accessPointConfig.ssid = "EvolutLight"           -- Name of the SSID you want to create
    --wifiConfig.accessPointConfig.pwd = ""                   -- WiFi password - at least 8 characters
    
    wifiConfig.accessPointIpConfig = {}
    wifiConfig.accessPointIpConfig.ip = "192.168.110.33"
    wifiConfig.accessPointIpConfig.netmask = "255.255.255.0"
    wifiConfig.accessPointIpConfig.gateway = "192.168.110.1"
    
    wifiConfig.stationPointConfig = {}
    wifiConfig.stationPointConfig.ssid = SSID               -- Name of the WiFi network you want to join
    wifiConfig.stationPointConfig.pwd =  PWD                -- Password for the WiFi network
    
    -- Tell the chip to connect to the access point
    
    wifi.setmode(wifiConfig.mode)
    print('set (mode='..wifi.getmode()..')')
    
    if (wifiConfig.mode == wifi.SOFTAP) or (wifiConfig.mode == wifi.STATIONAP) then
        print('AP MAC: ',wifi.ap.getmac())
        wifi.ap.config(wifiConfig.accessPointConfig)
        --wifi.ap.setip(wifiConfig.accessPointIpConfig)
    end
    if (wifiConfig.mode == wifi.STATION) or (wifiConfig.mode == wifi.STATIONAP) then
        print('Client MAC: ',wifi.sta.getmac())
        wifi.sta.config(wifiConfig.stationPointConfig.ssid, wifiConfig.stationPointConfig.pwd, 1)
    end
    
    print('chip: ',node.chipid())
    print('heap: ',node.heap())
    
    wifiConfig = nil
    collectgarbage()
    
    -- End WiFi configuration
    
    -- Compile server code and remove original .lua files.
    -- This only happens the first time afer the .lua files are uploaded.
    
    local compileAndRemoveIfNeeded = function(f)
       if file.open(f) then
          file.close()
          print('Compiling:', f)
          node.compile(f)
          file.remove(f)
          collectgarbage()
       end
    end
    
    
    local httpfiles = {
       'garage_door_opener.css',
       'underconstruction.gif',
       'zipped.html.gz',
       'cars-ferrari.jpg',
       'cars-lambo.jpg',
       'cars-mas.jpg',
       'cars-porsche.jpg',
       'args.lua',
       'file_list.lua',
       'garage_door_opener.lua',
       'node_info.lua',
       'post.lua',
       'apple-touch-icon.png',
       'cars.html',
       'garage_door_opener.html',   
       'index.html',  
       'range.html', 
       'range2.htm', 
       'range2.html',
       'favicon.ico',
       'favicon.gif',
    }
    for i, f in ipairs(httpfiles) do
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
    
    httpfiles=nil
    
    local serverFiles = {
       'httpserver.lua',
       'httpserver-b64decode.lua',
       'httpserver-basicauth.lua',
       'httpserver-conf.lua',
       'httpserver-connection.lua',
       'httpserver-error.lua',
       'httpserver-header.lua',
       'httpserver-request.lua',
       'httpserver-static.lua',
    }
    for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end
    
    compileAndRemoveIfNeeded = nil
    serverFiles = nil
    collectgarbage()
    serverFiles=nil
    
    -- Connect to the WiFi access point.
    -- Once the device is connected, you may start the HTTP server.
    
    if (wifi.getmode() == wifi.STATION) or (wifi.getmode() == wifi.STATIONAP) then
        local joinCounter = 0
        local joinMaxAttempts = 5
        tmr.alarm(0, 3000, 1, function()
           local ip = wifi.sta.getip()
           if ip == nil and joinCounter < joinMaxAttempts then
              print('Connecting to WiFi Access Point ...')
              joinCounter = joinCounter +1
           else
              if joinCounter == joinMaxAttempts then
                 print('Failed to connect to WiFi Access Point.')
              else
                 print('IP: ',ip)
              end
              tmr.stop(0)
              joinCounter = nil
              joinMaxAttempts = nil
              collectgarbage()
           end
        end)
    end
    
    -- Uncomment to automatically start the server in port 80
    if (not not wifi.sta.getip()) or (not not wifi.ap.getip()) then
        dofile("httpserver.lc")(80)
    end
end -- fct initwebserver

