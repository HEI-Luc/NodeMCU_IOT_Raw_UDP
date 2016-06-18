
return function (connection, req, args)

	if args.Node then
		args.Node=tonumber(args.Node)
		if args.R then
			allvalues[args.Node].R = tonumber(args.R)
		end
		if args.G then
			allvalues[args.Node].G = tonumber(args.G)
		end
		if args.B then
			allvalues[args.Node].B =  tonumber(args.B)
		end  
		if args.W then
			allvalues[args.Node].W =  tonumber(args.W)
		end  
	else-- brodcast
		if args.R then
			allvalues[1].R = tonumber(args.R)
			allvalues[2].R = tonumber(args.R)
			allvalues[3].R = tonumber(args.R)
			R = tonumber(args.R)
		end
		if args.G then
			allvalues[1].G = tonumber(args.G)
			allvalues[2].G = tonumber(args.G)
			allvalues[3].G = tonumber(args.G)
			G = tonumber(args.G)
		end
		if args.B then
			allvalues[1].B =  tonumber(args.B)
			allvalues[2].B =  tonumber(args.B)
			allvalues[3].B =  tonumber(args.B)
			B =  tonumber(args.B)
		end  
		if args.W then
			allvalues[1].W =  tonumber(args.W)
			allvalues[2].W =  tonumber(args.W)
			allvalues[3].W =  tonumber(args.W)
			W =  tonumber(args.W)
		end  
	end

    --LedColor=HSV(rainbow_index,Color,WHITE)
    --LedColor=string.char(G,R,B,W)
    LedRefresh()
    
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
