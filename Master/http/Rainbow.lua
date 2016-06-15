function HSV(Hue,div,white)	--Convertisseur HSV
    print("Hue: ",Hue," div ", div, " white ",white)
  if Hue < 85 then
    return string.char(Hue * 3 / div, (255 - Hue * 3) / div, 0,white)
  elseif Hue < 170 then
    Hue = Hue - 85
    return string.char((255 - Hue * 3) / div, 0, Hue * 3 / div,white)
  else
    Hue = Hue - 170
    return string.char(0, Hue * 3 / div, (255 - Hue * 3) / div,white)
  end
  Hue=nil
  div=nil
  white=nil
end

return function (connection, req, args)

	if args.PC then
		Color = tonumber(args.PC)
	--else
	--	Color=32
	end
	if args.HUE then
		rainbow_index = tonumber(args.HUE)
	--else
	--	rainbow_index = 60
	end
	if args.PW then
		WHITE =  tonumber(args.PW)
	--else
	--	WHITE = 128
	end  

    LedColor=HSV(rainbow_index,Color,WHITE)
    LedRefresh()
    
	
	--Color=nil
	--rainbow_index=nil
	--WHITE=nil
    HSV=nil

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
