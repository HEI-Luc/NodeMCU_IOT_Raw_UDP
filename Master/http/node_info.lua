local function sendAttr(connection, attr, val)
   connection:send("<li><b>".. attr .. ":</b> " .. val .. "<br></li>\n")
end

return function (connection, req, args)
   dofile("httpserver-header.lc")(connection, 200, 'html')
   connection:send('<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>A Lua script sample</title></head><body><h1>Node info</h1><ul>')
   majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();
   print(node.info())
   sendAttr(connection, "NodeMCU version"       , majorVer.."."..minorVer.."."..devVer)
   sendAttr(connection, "chipid"                , chipid)
   sendAttr(connection, "flashid"               , flashid)
   sendAttr(connection, "flashsize"             , flashsize)
   sendAttr(connection, "flashmode"             , flashmode)
   sendAttr(connection, "flashspeed"            , flashspeed)
   sendAttr(connection, "node.heap()"           , node.heap())
   sendAttr(connection, 'Memory in use (KB)'    , collectgarbage("count"))
	if(wifi.sta.status==5)then
	   sendAttr(connection, 'STA IP address'            , wifi.sta.getip())
	   sendAttr(connection, 'STA MAC address'           , wifi.sta.getmac())
	end
	
   sendAttr(connection, 'AP IP address'            , wifi.ap.getip())
   sendAttr(connection, 'AP MAC address'           , wifi.ap.getmac())
	
   connection:send('</ul></body></html>')
end
