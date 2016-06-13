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
            connectionThread = coroutine.create(function(fileServeFunction, bufferedConnection, req, args)
               fileServeFunction(bufferedConnection, req, args)
               -- The bufferedConnection may still hold some data that hasn't been sent. Flush it before closing.
               if not bufferedConnection:flush() then
                  connection:close()
                  connectionThread = nil
               end
            end)

			print("Before buffered",node.heap())
            local BufferedConnectionClass = dofile("httpserver-connection.lc")
			print("after buffered class",node.heap())
            local bufferedConnection = BufferedConnectionClass:new(connection)
			print("after new connection",node.heap())
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
                      
			   local fileExists = file.open(uri.file, "r")
			   file.close()
			   
			   if not fileExists then
				  -- gzip check
				  print(uri.file.." non trouve, heap ",node.heap())
				  
				  fileExists = file.open(uri.file .. ".gz", "r")
				  file.close()

				  if fileExists then
					 --print("gzip variant exists, serving that one")
					 uri.file = uri.file .. ".gz"
					 uri.isGzipped = true
				  end
			   else
			  
					print(uri.file.." appel equivoque")
					request=uri.file
					 
					 startString = string.find(request, "/")
					 finString   = string.find(request, "=")
					
					if(startString~=nil and finString~=nil)then

						startString=startString+1
						finString=finString-1

						print(startString)
						print(finString)
					    param = string.sub(request,startString,finString)
						
					    print("Param: ",param)
						
					    startString=finString+2;
				        finString = string.find(uri.file, ",")-1
						
				        value = string.sub(uri.file,startString,finString)
						
				        print("Value: ",value)
						print("Heap: ",node.heap())
						
				        if(param=="div")then
				            div=value
				        elseif(param=="bright")then
				            WHITE_PWR=value
				        elseif(param=="led")then
				            NB_LED = value  
				        end

				        --CheckStation()
						uri.args = {code = 200, errorString = "Ordre recu"}
						fileServeFunction = dofile("httpserver-error.lc")
						  
					end
		   
						if not fileExists then
						  uri.args = {code = 404, errorString = "Not Found"}
						  fileServeFunction = dofile("httpserver-error.lc")
					   elseif uri.isScript then
						  fileServeFunction = dofile(uri.file)
					   else
						  if allowStatic[method] then
							 uri.args = {file = uri.file, ext = uri.ext, isGzipped = uri.isGzipped}
							 fileServeFunction = dofile("httpserver-static.lc")
						  else
							 uri.args = {code = 405, errorString = "Method not supported"}
							 fileServeFunction = dofile("httpserver-error.lc")
						  end
					   end
					--end--if pilotage
					startServing(fileServeFunction, connection, req, uri.args)--envoie du fichier ou de l'aquitement
                end --if fichier
            end--if longueur
         end--end fct

         local function onReceive(connection, payload)
			print("onReceive Heap: ",node.heap())
            collectgarbage()
			print("apres collect garbage Heap: ",node.heap())
            --local conf = dofile("httpserver-conf.lc")
		--	print("apres conf Heap: ",node.heap())
        --    local auth
        --    local user = "Anonymous"

            -- as suggest by anyn99 (https://github.com/marcoskirsch/nodemcu-httpserver/issues/36#issuecomment-167442461)
            -- Some browsers send the POST data in multiple chunks.
            -- Collect data packets until the size of HTTP body meets the Content-Length stated in header
            if payload:find("Content%-Length:") or bBodyMissing then
               if fullPayload then fullPayload = fullPayload .. payload else fullPayload = payload end
               if (tonumber(string.match(fullPayload, "%d+", fullPayload:find("Content%-Length:")+16)) > #fullPayload:sub(fullPayload:find("\r\n\r\n", 1, true)+4, #fullPayload)) then
                  bBodyMissing = true
                  return
               else
                  --print("HTTP packet assembled! size: "..#fullPayload)
                  payload = fullPayload
                  fullPayload, bBodyMissing = nil
               end
            end
            collectgarbage()

            -- parse payload and decide what to serve.
            local req = dofile("httpserver-request.lc")(payload)
			print("apres request Heap: ",node.heap())
            print(req.method .. ": " .. req.request)
			
      --      if conf.auth.enabled then
      --         auth = dofile("httpserver-basicauth.lc")
     --          user = auth.authenticate(payload) -- authenticate returns nil on failed auth
      --      end

           -- if user and req.methodIsValid and (req.method == "GET" or req.method == "POST" or req.method == "PUT") then
			if req.methodIsValid and (req.method == "GET" or req.method == "POST" or req.method == "PUT") then
               handleRequest(connection, req)
            else
               local args = {}
               local fileServeFunction = dofile("httpserver-error.lc")
          --     if not user then
          --        args = {code = 401, errorString = "Not Authorized", headers = {auth.authErrorHeader()}}
          --     else
			   if req.methodIsValid then
                  args = {code = 501, errorString = "Not Implemented"}
               else
                  args = {code = 400, errorString = "Bad Request"}
               end
               startServing(fileServeFunction, connection, req, args)
            end
         end

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
                  -- We're done sending file.
                  connection:close()
                  connectionThread = nil
               end
            end
         end

         local function onDisconnect(connection, payload)
            if connectionThread then
               connectionThread = nil
               collectgarbage()
            end
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
