--Include sqlite
local RestManager = {}

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
		url = url.."/city/"..city
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					DBManager.updateUser(data.items[1].id, data.items[1].email, data.items[1].contrasena, data.items[1].nombre, data.items[1].ciudadesId, data.items[1].residencialId)
                    gotoLoginGuard()
                else
                    native.showAlert( "Booking", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	RestManager.validateGuard = function(password, idGuard)
	
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
					gotoHome(data.items[1].id)
					--DBManager.updateUser(data.items[1].id, data.items[1].email, data.items[1].contrasena, data.items[1].nombre, data.items[1].ciudadesId, data.items[1].residencialId)
                    --gotoLoginGuard()
                else
                    native.showAlert( "Booking", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	RestManager.signOut = function(password)
	
        local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/signOut/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/password/"..password
		
		print(url)
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					DBManager.clearUser()
					signOut()
                else
                    native.showAlert( "Booking", data.message, { "OK"})
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
					native.showAlert( "Booking", data.message, { "OK"})
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
                    native.showAlert( "Booking", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
       network.request( url, "GET", callback ) 
    end
	
return RestManager