
return function (connection, req, args)

	if args.Off1 then
		allvalues[1].OFF = 1
		allvalues[1].NewValue =1
	else
		allvalues[1].OFF = 0
		allvalues[1].NewValue =1
	end
	if args.Off2 then
		allvalues[2].OFF = 1
		allvalues[2].NewValue =1
	else
		allvalues[2].OFF = 0
		allvalues[2].NewValue =1
	end
	if args.Node then
		args.Node=tonumber(args.Node)
		if args.R then
			allvalues[args.Node].R = tonumber(args.R)
			allvalues[args.Node].NewValue =1
		end
		if args.G then
			allvalues[args.Node].G = tonumber(args.G)
			allvalues[args.Node].NewValue =1
		end
		if args.B then
			allvalues[args.Node].B =  tonumber(args.B)
			allvalues[args.Node].NewValue =1
		end  
		if args.W then
			allvalues[args.Node].W =  tonumber(args.W)
			allvalues[args.Node].NewValue =1
		end  
	else-- brodcast
		if args.R then
			allvalues[1].R = tonumber(args.R)
			allvalues[2].R = tonumber(args.R)
			
			allvalues[2].NewValue =1
			--R = tonumber(args.R)
		end
		if args.G then
			allvalues[1].G = tonumber(args.G)
			allvalues[2].G = tonumber(args.G)
			
			allvalues[2].NewValue =1
			--G = tonumber(args.G)
		end
		if args.B then
			allvalues[1].B =  tonumber(args.B)
			allvalues[2].B =  tonumber(args.B)
			
			allvalues[2].NewValue =1
			--B =  tonumber(args.B)
		end  
		if args.W then
			allvalues[1].W =  tonumber(args.W)
			allvalues[2].W =  tonumber(args.W)
			
			allvalues[2].NewValue =1
			--W =  tonumber(args.W)
		end  
	end

    --LedColor=HSV(rainbow_index,Color,WHITE)
    --LedColor=string.char(G,R,B,W)
   
   
   CheckStation()
   tmr.alarm(1, 150, tmr.ALARM_SINGLE, LedRefresh)
   --LedRefresh()
    
    collectgarbage()
    print("Acquitement ",node.heap())
	
   dofile("httpserver-header.lc")(connection, 200, 'html')
   connection:send([===[
   <!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Arguments by GET</title></head><body><h1>Arguments by GET</h1>
   ]===])
       if args.debug then
          connection:send("<h2>Received the following values:</h2><ul>")
          for name, value in pairs(args) do
             connection:send('<li><b>' .. name .. ':</b> ' .. tostring(value) .. "<br></li>\n")
          end
          connection:send("</ul>\n")
       end
   
   connection:send("</body></html>")
end
