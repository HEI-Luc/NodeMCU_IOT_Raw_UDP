                    
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
        
    wifi.setmode(wifiConfig.mode)
    print('set (mode='..wifi.getmode()..')')
    
    if (wifiConfig.mode == wifi.SOFTAP) or (wifiConfig.mode == wifi.STATIONAP) then
        print('AP MAC: ',wifi.ap.getmac())
        wifi.ap.config(wifiConfig.accessPointConfig)
        --wifi.ap.setip(wifiConfig.accessPointIpConfig)
        print ("Le point d'acces qui emet est "..wifiConfig.accessPointConfig.ssid)
    end
    
    print('chip: ',node.chipid())
    print('heap: ',node.heap())
    
    wifiConfig = nil
    collectgarbage()
   
        dofile("httpserver.lc")(80)
   
end -- fct initwebserver

