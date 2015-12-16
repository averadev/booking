--Include sqlite
local RestManager = {}

	require('src.BuildItem')
	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
	local DBManager = require('src.resources.DBManager')
    local Globals = require('src.resources.Globals')
	
	local settings = DBManager.getSettings()
	
	function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end
	
	RestManager.validateAdmin = function(email, password, city)
	
        local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/validateAdmin/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/email/"..urlencode(email)
        url = url.."/password/"..password
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					NewAlert("Plantec Security","Usuario correcto", 0)
					DBManager.updateUser(data.items[1].id, data.items[1].email, data.items[1].contrasena, data.items[1].nombre, data.items[1].ciudadesId, data.items[1].residencialId)
					DBManager.insertGuard(data.items2)
					DBManager.insertCondominium(data.items3)
					DBManager.insertResidential(data.items4)
					setItemsGuard(data.items2)
                else
                    --native.showAlert( "Plantec Security", data.message, { "OK"})
					NewAlert("Plantec Security","Usuario Incorrecto", 0)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteNewAlert()
					end, 1 )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	--[[RestManager.validateGuard = function(password, idGuard)
	
        local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/validateGuard/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/idGuard/"..idGuard
        url = url.."/password/"..password
		
		print(url)
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					gotoHome(data.items[1].id,data.items[1].nombre,data.items[1].foto)
					--DBManager.updateUser(data.items[1].id, data.items[1].email, data.items[1].contrasena, data.items[1].nombre, data.items[1].ciudadesId, data.items[1].residencialId)
                    --gotoLoginGuard()
                else
                    --native.showAlert( "Plantec Security", data.message, { "OK"})
					NewAlert(data.message, 600, 200, 2000)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteNewAlert()
					end, 1 )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end]]
	
	RestManager.signOut = function(password)
	
        local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/signOut/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/password/"..password
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					DBManager.clearUser()
					signOut()
                else
                    --native.showAlert( "Plantec Security", data.message, { "OK"})
					NewAlert("Plantec Security",data.message, 0)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteNewAlert()
					end, 1 )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	RestManager.getCity = function()
	
        local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getCity/format/json"
		
		--print(url)
    
        local function callback(event)
            if ( event.isError ) then
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
                if data.success then
					setItemsCity(data.items)
                else
					native.showAlert( "Plantec Security", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
       network.request( url, "GET", callback ) 
    end
	
	--obtiene los guardias por recidencia
	RestManager.getInfoGuard = function()
	
        local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getInfoGuard/format/json"
		--url = url.."/idApp/"..settings.idApp
		url = url.."/recidencial/"..settings.residencial
		
		--print(url)
    
        local function callback(event)
            if ( event.isError ) then
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
                if data.success then
					setItemsGuard(data.items)
                else
                    native.showAlert( "Plantec Security", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
       network.request( url, "GET", callback ) 
    end
	
	RestManager.sendMessagesGuard = function()
		
		if Globals.ItIsUploading == 0 then
			if networkConnection() then 
				Globals.ItIsUploading = 1
				local messagesSend = DBManager.getMessageUnsent(1)
				sendMessageGuard(1,messagesSend,1)
			else
				Globals.ItIsUploading = 0
				NewAlert("Plantec Security","Mensaje enviado.", 0)
				timeMarker = timer.performWithDelay( 2000, function()
					deleteNewAlert()
					goToLoginGuardMSGAdmin()
				end, 1 )
			end
		else
			NewAlert("Plantec Security","Mensaje enviado.", 0)
			timeMarker = timer.performWithDelay( 2000, function()
				deleteNewAlert()
				goToLoginGuardMSGAdmin()
			end, 1 )
		end
	end
	
	--envia el mensaje a admistracion
	function sendMessageGuard(posc, items, typeM)
	
        local settings = DBManager.getSettings()
		local settingsuard = DBManager.getSettings()
		
        -- Set url
        local url = settings.url
        url = url.."api/saveMessageGuard/format/json"
		url = url.."/idApp/"..settings.idApp
		url = url.."/idMSG/"..items[posc].id
		url = url.."/idGuard/"..items[posc].empleadosId
		url = url.."/subject/"..urlencode(items[posc].asunto)
		url = url.."/message/"..urlencode(items[posc].mensaje)
		url = url.."/dateS/"..urlencode(items[posc].fechaHora)
		
        local function callback(event)
            if ( event.isError ) then
				if typeM == 1 then
					NewAlert("Plantec Security","Mensaje enviado.", 0)
					timeMarker = timer.performWithDelay( 2000, function()
						Globals.ItIsUploading = 0
						deleteNewAlert()
						goToLoginGuardMSGAdmin()
					end, 1 )
				else
					Globals.ItIsUploading = 0
				end
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
				if data then
					if data.success then
					
						DBManager.updateMessageGuard(data.items)
						if posc == #items then
							if typeM == 1 then
								NewAlert("Plantec Security","Mensaje enviado.", 0)
								timeMarker = timer.performWithDelay( 2000, function()
									Globals.ItIsUploading = 0
									deleteNewAlert()
									goToLoginGuardMSGAdmin()
								end, 1 )
							else
								RestManager.checkUnsentMessage(2)
							end
						else
							sendMessageGuard(posc + 1, items, typeM)
						end
						--MessageSendToAdmin()
						--setItemsGuard(data.items)
					else
						--native.showAlert( "Plantec Security", data.message, { "OK"})
						if typeM == 1 then
							NewAlert("Plantec Security","Mensaje enviado.", 0)
							timeMarker = timer.performWithDelay( 2000, function()
								Globals.ItIsUploading = 0
								deleteNewAlert()
								goToLoginGuardMSGAdmin()
							end, 1 )
						else
							Globals.ItIsUploading = 0
						end
					end
				else
					if typeM == 1 then
						NewAlert("Mensaje enviado.", 0)
						timeMarker = timer.performWithDelay( 2000, function()
							Globals.ItIsUploading = 0
							deleteNewAlert()
							goToLoginGuardMSGAdmin()
						end, 1 )
					else
						Globals.ItIsUploading = 0
					end
				end
            end
            return true
        end
        -- Do request
       network.request( url, "GET", callback ) 
    end
	
	--envia los mensaje de visitas
	RestManager.sendMSGRecordVisit = function()
	
		local residencial = DBManager.getResidential()
		print(residencial)
		local requireFoto = 0
		if residencial == 0 then
			requireFoto = 1
		else
			requireFoto = residencial[1].requireFoto
		end	
		print("requireFoto")
		print(requireFoto)
		
		if Globals.ItIsUploading == 0 then
			if networkConnection() then 
				Globals.ItIsUploading = 1
				local messagesSend = DBManager.getMessageUnsent(2)
				if requireFoto == 1 then
				print('holalsaaasdadas')
				uploadImage(1,messagesSend,1, 1)
				else
					sendMRecordVisit(1, messagesSend ,1)
				end
			else
				NewAlert("Plantec Security","Mensaje enviado.", 600, 200)
				timeMarker = timer.performWithDelay( 2000, function()
					Globals.ItIsUploading = 0
					deleteNewAlert()
					goToNotificationMSG()
				end, 1 )
			end
		else
			NewAlert("Plantec Security","Mensaje enviado.", 600, 200)
			timeMarker = timer.performWithDelay( 2000, function()
				--Globals.ItIsUploading = 0
				deleteNewAlert()
				goToNotificationMSG()
			end, 1 )
		end
	end
	
	
	--envia el registro del visitante
	function sendMRecordVisit(posc, items, typeM)
	
        local settings = DBManager.getSettings()
		local settingsuard = DBManager.getSettings()
		
		local residencial = DBManager.getResidential()
		local requireFoto = 0
		if residencial == 0 then
			requireFoto = 1
		else
			requireFoto = residencial[1].requireFoto
		end	
		
        -- Set url
        local url = settings.url
        url = url.."api/saveRecordVisit/format/json"
		url = url.."/idApp/"..settings.idApp
		url = url.."/idMSG/"..items[posc].id
		url = url.."/idGuard/"..items[posc].empleadosId
		url = url.."/name/"..urlencode(items[posc].nombreVisitante)
		url = url.."/reason/"..urlencode(items[posc].motivo)
		url = url.."/idFrente/"..urlencode(items[posc].idFrente)
		url = url.."/idVuelta/"..urlencode(items[posc].idVuelta)
		url = url.."/condominiosId/"..urlencode(items[posc].condominiosId)
		url = url.."/provider/"..urlencode(items[posc].proveedor)
		url = url.."/dateS/"..urlencode(items[posc].fechaHora)
		
        local function callback(event)
            if ( event.isError ) then
				if typeM == 1 then
					NewAlert("Plantec Security","Mensaje enviado.", 600, 200)
					timeMarker = timer.performWithDelay( 2000, function()
						Globals.ItIsUploading = 0
						deleteNewAlert()
						goToNotificationMSG()
					end, 1 )
				else
					Globals.ItIsUploading = 0
				end
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
				if data then
					if data.success then
						local result = DBManager.updateRecordVisit(data.items)
						if result == 0 then
							deleteImageRecordVisit(items[posc].idFrente,items[posc].idVuelta)
						end
						if posc == #items then
							if typeM == 1 then
								NewAlert("Plantec Security","Mensaje enviado.", 600, 200)
								timeMarker = timer.performWithDelay( 2000, function()
									Globals.ItIsUploading = 0
									deleteNewAlert()
									goToNotificationMSG()
								end, 1 )
							else
								Globals.ItIsUploading = 0
							end
						else
							if requireFoto == 1 then
								uploadImage(posc + 1, items, 1, typeM)
							else
								sendMRecordVisit(posc + 1, items, typeM)
							end
						end
						--MessageSendToAdmin()
						--setItemsGuard(data.items)
					else
						--native.showAlert( "Plantec Security", data.message, { "OK"})
						if typeM == 1 then
							NewAlert("Plantec Security","Mensaje enviado.", 600, 200)
							timeMarker = timer.performWithDelay( 2000, function()
								Globals.ItIsUploading = 0
								deleteNewAlert()
								goToNotificationMSG()
							end, 1 )
						else
							Globals.ItIsUploading = 0
						end
					end
				else
					if typeM == 1 then
						NewAlert("Plantec Security","Mensaje enviado.", 600, 200)
						timeMarker = timer.performWithDelay( 2000, function()
							Globals.ItIsUploading = 0
							deleteNewAlert()
							goToNotificationMSG()
						end, 1 )
					else
						Globals.ItIsUploading = 0
					end
				end
            end
            return true
        end
        -- Do request
       network.request( url, "GET", callback ) 
    end
	
	function uploadImage(posc, items, numImage, typeM)
		local settings = DBManager.getSettings()
	
		local function networkListener( event )

			if ( event.isError ) then
				print( "Network Error." )
				if typeM == 1 then
					NewAlert("Plantec Security","Mensaje enviado.", 600, 200)
						timeMarker = timer.performWithDelay( 2000, function()
						Globals.ItIsUploading = 0
						deleteNewAlert()
						goToNotificationMSG()
					end, 1 )
				else
					Globals.ItIsUploading = 0
				end
			else
				if ( event.phase == "began" ) then
					--print( "Upload started" )
				elseif ( event.phase == "progress" ) then
					--print( "Uploading... bytes transferred ", event.bytesTransferred )
				elseif ( event.phase == "ended" ) then
					--print( "Upload ended..." )
					--print( "Status:", event.status )
					--print( "Response:", event.response )
					
					if event.status == 201 then
						
						if numImage == 1 then
							uploadImage(posc, items, numImage + 1, typeM)
						else
							sendMRecordVisit(posc, items, typeM)
						end
						
					else
						if typeM == 1 then
							NewAlert("Plantec Security","Mensaje enviado.", 600, 200)
							timeMarker = timer.performWithDelay( 2000, function()
								Globals.ItIsUploading = 0
								deleteNewAlert()
								goToNotificationMSG()
							end, 1 )
						else
							Globals.ItIsUploading = 0
						end
					end
					
					
				end
			end
			
		end

		local url = settings.url .. "upload/uploadImage"
		
		local params = {
			timeout = 60,
			progress = true,
			bodyType = "text"
		}
		
		local filename
		
		if numImage == 1 then
			filename = "tempFotos/" .. items[posc].idFrente
		else
			filename = "tempFotos/" .. items[posc].idVuelta
		end
		
		print ('nameFoto2 ' .. items[posc].idFrente)
		
		local baseDirectory = system.TemporaryDirectory
		local contentType = "image/jpeg"
		
		local headers = {}

		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		headers.filename = filename
		params.headers = headers

		--network.request( "http://localhost:8080/booking/upload/uploadImage", "POST", networkListener, params )
		network.upload( url , "PUT", networkListener, params, filename, baseDirectory, contentType )
	
	end
	
	--sube los mensaje no enviados
	RestManager.checkUnsentMessage = function(num)
		
		if networkConnection() then 
		
			Globals.ItIsUploading = 1
			if num == 1 then
				
				local messagesSend = DBManager.getMessageUnsent(1)
				if messagesSend == 1 then
					RestManager.checkUnsentMessage(2)
				else
					sendMessageGuard(1,messagesSend, 2)
				end
			else
				local messagesSend = DBManager.getMessageUnsent(2)
				if messagesSend == 1 then
					Globals.ItIsUploading = 0
				else
					uploadImage(1,messagesSend,1, 2)
				end
				
			end
		
			
			
		else
			Globals.ItIsUploading = 0
		end
		
		
		
	end
	
	--obtiene la fecha actual
	RestManager.getDate = function()
		local date = os.date( "*t" )    -- Returns table of date & time values
		local year = date.year
		local month = date.month
		local day = date.day
		local hour = date.hour
		local minute = date.hour
		local segunds = date.sec 
		
		if month < 10 then
			month = "0" .. month
		end
		
		if day < 10 then
			day = "0" .. day
		end
		
		return year .. "-" .. month .. "-" .. day .. " " .. hour .. ":" .. minute .. ":" .. segunds
	end
	
	RestManager.getDateCompound = function()
		local date = os.date( "*t" )    -- Returns table of date & time values
		local year = date.year
		local month = date.month
		local day = date.day
		local hour = date.hour
		local minute = date.hour
		local segunds = date.sec 
		
		if month < 10 then
			month = "0" .. month
		end
		
		if day < 10 then
			day = "0" .. day
		end
		
		return year .. "-" .. month .. "-" .. day .. "T" .. hour .. ":" .. minute .. ":" .. segunds .. ".1-0400" 
	end
	
	-- obtiene un timestamp
	RestManager.getTimeStamp = function(dateString)
		
		local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%p])(%d%d)%:?(%d%d)"
		local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin =
		dateString:match(pattern)
		local timestamp = os.time(
			{year=year, month=month, day=day, hour=hour, min=minute, sec=seconds} )
		local offset = 0
		if ( tzoffset ) then
			if ( tzoffset == "+" or tzoffset == "-" ) then  -- we have a timezone!
				offset = offsethour * 60 + offsetmin
				if ( tzoffset == "-" ) then
					offset = offset * -1
				end
				timestamp = timestamp + offset
			end
		end
		return timestamp	
	end
	
	--comprueba si existe conexion a internet
	function networkConnection()
		local netConn = require('socket').connect('www.google.com', 80)
		if netConn == nil then
			return false
		end
		netConn:close()
		return true
	end
	
return RestManager