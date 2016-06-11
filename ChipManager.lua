	print("ChipID:"..node.chipid())
	
	--142598
	--1139462
	--1140291
	--14056654
	--14057049
	--14057245

	allvalues = 
	{
	   {chip = 142598, 		ip = 0,	range = 1, color = 176, value = 0,  temperature = 511,  bright = 0},
	   {chip = 1139462, 	ip = 0, range = 2, color = 176, value = 0,  temperature = 511,  bright = 0},
	   {chip = 1140291, 	ip = 0, range = 3, color = 176, value = 0,	temperature = 511,  bright = 0},
	   {chip = 14056654, 	ip = 0, range = 4, color = 176, value = 0,	temperature = 511,  bright = 0},
	   {chip = 14057049, 	ip = 0, range = 4, color = 176, value = 0,	temperature = 511,  bright = 0},
	   {chip = 14057245, 	ip = 0, range = 5, color = 176, value = 0,	temperature = 511,  bright = 0}
	}



	for k, v in ipairs(allvalues) do
	
		print(string.format("k=%s, v=%s",tostring(k),tostring(v)))
		
		if v.chip == node.chipid() then
			print("Node numero "..k.." de rang: "..allvalues[k].range)
			nodeId=k
			range=allvalues[k].range
		end
	end