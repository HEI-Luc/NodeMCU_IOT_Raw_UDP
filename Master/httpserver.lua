-- httpserver
-- Author: Marcos Kirsch

-- Starts web server in the specified port.
return function (port)

   local s = net.createServer(net.TCP, 10) -- 10 seconds client timeout
   s:listen(
      port,
      function (connection)

         -- This variable holds the thread (actually a Lua coroutine) used for sending data back to the user.
         -- We do it in a separate thread because we need to send in little chunks and wait for the onSent event
         -- before we can send more, or we risk overflowing the mcu's buffer.
         local connectionThread

         local allowStatic = {GET=true, HEAD=true, POST=false, PUT=false, DELETE=false, TRACE=false, OPTIONS=false, CONNECT=false, PATCH=false}

         local function startServing(fileServeFunction, connection, req, args)
			print("Start serving: ",fileServeFunction," ",node.heap())
            connectionThread = coroutine.create(function(fileServeFunction, bufferedConnection, req, args)
               fileServeFunction(bufferedConnection, req, args)
               -- The bufferedConnection may still hold some data that hasn't been sent. Flush it before closing.
               if not bufferedConnection:flush() then
                  connection:close()
                  connectionThread = nil
               end
            end)

            local BufferedConnectionClass = dofile("httpserver-connection.lc")
            local bufferedConnection = BufferedConnectionClass:new(connection)
			--print("after new connection",node.heap())
            local status, err = coroutine.resume(connectionThread, fileServeFunction, bufferedConnection, req, args)
            if not status then
               print("Avant print error : ",node.heap())
               print("Error: ", err)
            end
         end

         local function handleRequest(connection, req)
            collectgarbage()
            local method = req.method
            local uri = req.uri
            local fileServeFunction = nil

            if #(uri.file) > 32 then
               -- nodemcu-firmware cannot handle long filenames.
               uri.args = {code = 400, errorString = "Bad Request"}
               fileServeFunction = dofile("httpserver-error.lc")
            else
                      
				 
				if file.open(uri.file, "r") then
					file.close()
					--print(uri.file.." Existe ",node.heap())
			   
				else
				  -- gzip check
				  print(uri.file.." non trouve, heap ",node.heap())
				  
					if file.open(uri.file .. ".gz", "r") then
						file.close()
						--print("gzip variant exists, serving that one")
						uri.file = uri.file .. ".gz"
						uri.isGzipped = true
					
					else -- ordre lampe
				  
						uri.args = {code = 404, errorString = "Not Found"}
						fileServeFunction = dofile("httpserver-error.lc")
						
					end --if nom.gzip
				end --if nom brute
				
				if uri.isScript then
					
					fileServeFunction = dofile(uri.file)
				else
					print("Page statique")
					if allowStatic[method] then
						uri.args = {file = uri.file, ext = uri.ext, isGzipped = uri.isGzipped}
						fileServeFunction = dofile("httpserver-static.lc")
					else
						uri.args = {code = 405, errorString = "Method not supported"}
						fileServeFunction = dofile("httpserver-error.lc")
					end
				end
            end--if longueur
			startServing(fileServeFunction, connection, req, uri.args)--envoie du fichier ou de l'aquitement
         end--end fct

        local function onReceive(connection, payload)
				collectgarbage()
				print("onReceive Heap: ",node.heap())
			if not connectionThread then -- connection nulle => pas d'envoi en cours, on écoute la requete
				print("Connection prise en compte ",connectionThread)
		
				if payload:find("Content%-Length:") or bBodyMissing then
				   if fullPayload then fullPayload = fullPayload .. payload else fullPayload = payload end
				   if (tonumber(string.match(fullPayload, "%d+", fullPayload:find("Content%-Length:")+16)) > #fullPayload:sub(fullPayload:find("\r\n\r\n", 1, true)+4, #fullPayload)) then
					  bBodyMissing = true
					  return
				   else
					 
					  payload = fullPayload
					  fullPayload, bBodyMissing = nil
				   end
				end
				collectgarbage()

				-- parse payload and decide what to serve.
				local req = dofile("httpserver-request.lc")(payload)
				collectgarbage()
				print("Apres parse request Heap: ",node.heap())
				print(req.method .. ": " .. req.request)
				
		

			   -- if user and req.methodIsValid and (req.method == "GET" or req.method == "POST" or req.method == "PUT") then
				if req.methodIsValid and (req.method == "GET" or req.method == "POST" or req.method == "PUT") then
				   handleRequest(connection, req)
				else
				   local args = {}
				   local fileServeFunction = dofile("httpserver-error.lc")
			 
				   if req.methodIsValid then
					  args = {code = 501, errorString = "Not Implemented"}
				   else
					  args = {code = 400, errorString = "Bad Request"}
				   end
				   startServing(fileServeFunction, connection, req, args)
				end
			else
				print("Connection refuse ",connectionThread)
			end-- if thread
         end -- end onReceive

         local function onSent(connection, payload)
            collectgarbage()
            if connectionThread then
               local connectionThreadStatus = coroutine.status(connectionThread)
               if connectionThreadStatus == "suspended" then
                  -- Not finished sending file, resume.
                  local status, err = coroutine.resume(connectionThread)
                  if not status then
                     print(err)
                  end
               elseif connectionThreadStatus == "dead" then
					print("Envoi termine ",connectionThread)
					-- We're done sending file.
					connection:close()
					connectionThread = nil
					collectgarbage()
               end
            end
         end

         local function onDisconnect(connection, payload)
            if connectionThread then
				print("connection avorte",connectionThread)
				connectionThread = nil
            end
			collectgarbage()
            print("Deconnection", node.heap())
			CheckStation()
         end

         connection:on("receive", onReceive)
         connection:on("sent", onSent)
         connection:on("disconnection", onDisconnect)

      end
   )
   -- false and nil evaluate as false
   local ip = wifi.sta.getip()
   if not ip then ip = wifi.ap.getip() end
   if not ip then ip = "unknown IP" end
   print("nodemcu-httpserver running at http://" .. ip .. ":" ..  port)
   return s

end
