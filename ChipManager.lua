	print("ChipID:"..node.chipid())

    remaining, used, total=file.fsinfo()
    print("\nFile system info:\nTotal : "..total.." Bytes\nUsed : "..used.." Bytes\nRemain: "..remaining.." Bytes\n")
	
	--142598
	--1139462
	--1140291
	--14056654
	--14057049
	--14057245

	allvalues = 
	{
	   {chip = 142898, 		staMAC = "				   ", conn=nil, ip = 0, vu=0,    range = 1, W = 0, R = 0, G = 0,  B = 0},
	   {chip = 1139462, 	staMAC = "5c:cf:7f:11:63:06", conn=nil, ip = 0, vu=0,    range = 2, W = 0, R = 0, G = 0,  B = 0},
	   {chip = 1140291, 	staMAC = "5c:cf:7f:11:66:43", conn=nil, ip = 0, vu=0,    range = 3, W = 0, R = 0, G = 0,  B = 0},
	  -- {chip = 14056654, 	staMAC = "18:fe:34:d6:7c:ce", conn=nil,     ip = 0, vu=0,    range = 4, R = 176, value = 0,	temperature = 511,  bright = 0},
	  -- {chip = 14057049, 	staMAC = "", conn=nil,     ip = 0, vu=0,    range = 4, R = 176, value = 0,	temperature = 511,  bright = 0},
	  -- {chip = 14057245, 	staMAC = "", conn=nil,     ip = 0, vu=0,    range = 5, R = 176, value = 0,	temperature = 511,  bright = 0}
	}

	for k, v in ipairs(allvalues) do
		--print(string.format("k=%s, v=%s",tostring(k),tostring(v)))
		if v.chip == node.chipid() then
			print("Node numero "..k.." de rang: "..allvalues[k].range)
			nodeId=k
			range=allvalues[k].range
		end
	end

    print("Free Chip Manager")  
    collectgarbage()
    print(node.heap())   
