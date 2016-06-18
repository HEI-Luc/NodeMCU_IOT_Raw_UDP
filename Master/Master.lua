                    
function InitMaster()
    
    -- Begin WiFi configuration
    
    local wifiConfig = {}
    
    -- wifi.STATION         -- station: join a WiFi network
    -- wifi.SOFTAP          -- access point: create a WiFi network
    -- wifi.wifi.STATIONAP  -- both station and access point
    wifiConfig.mode = wifi.SOFTAP  -- both station and access point
    
    wifiConfig.accessPointConfig = {}
    wifiConfig.accessPointConfig.ssid = "EvolutLight"           -- Name of the SSID you want to create
    --wifiConfig.accessPointConfig.pwd = ""                   -- WiFi password - at least 8 characters
    
    --wifiConfig.accessPointIpConfig = {}
   -- wifiConfig.accessPointIpConfig.ip = "192.168.110.33"
   -- wifiConfig.accessPointIpConfig.netmask = "255.255.255.0"
   -- wifiConfig.accessPointIpConfig.gateway = "192.168.110.1"
    
    --wifiConfig.stationPointConfig = {}
    --wifiConfig.stationPointConfig.ssid = SSID               -- Name of the WiFi network you want to join
    --wifiConfig.stationPointConfig.pwd =  PWD                -- Password for the WiFi network
    --SSID=nil
    --PWD=nil
    -- Tell the chip to connect to the access point
    
    wifi.setmode(wifiConfig.mode)
    print('set (mode='..wifi.getmode()..')')
    
    if (wifiConfig.mode == wifi.SOFTAP) or (wifiConfig.mode == wifi.STATIONAP) then
        print('AP MAC: ',wifi.ap.getmac())
        wifi.ap.config(wifiConfig.accessPointConfig)
        --wifi.ap.setip(wifiConfig.accessPointIpConfig)
        print ("Le point d'acces qui emet est "..wifiConfig.accessPointConfig.ssid)
    end
 --   if (wifiConfig.mode == wifi.STATION) or (wifiConfig.mode == wifi.STATIONAP) then
 --       print('Client MAC: ',wifi.sta.getmac())
 --       wifi.sta.config(wifiConfig.stationPointConfig.ssid, wifiConfig.stationPointConfig.pwd, 1)
 --   end
    
    print('chip: ',node.chipid())
    print('heap: ',node.heap())
    
    wifiConfig = nil
    collectgarbage()
    
  
    
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
              print(node.heap())               
           end
        end)
    end
    
    -- Uncomment to automatically start the server in port 80
    if (not not wifi.sta.getip()) or (not not wifi.ap.getip()) then
        dofile("httpserver.lc")(80)
    end
end -- fct initwebserver

