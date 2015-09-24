--Include sqlite
local dbManager = {}

	require "sqlite3"
	local path, db
    local lfs = require "lfs"

	--Open rackem.db.  If the file doesn't exist it will be created
	local function openConnection( )
        local pathBase = system.pathForFile(nil, system.DocumentsDirectory)
        if findLast(pathBase, "/data/data") > -1 then
            local newFile = pathBase:gsub("/app_data", "") .. "/databases/booking.db"
            local fhd = io.open( newFile )
            if fhd then
                fhd:close()
            else
                local success = lfs.chdir(  pathBase:gsub("/app_data", "") )
                if success then
                    lfs.mkdir( "databases" )
                end
            end
            db = sqlite3.open( newFile )
        else
            db = sqlite3.open( system.pathForFile("booking.db", system.DocumentsDirectory) )
        end
	end

	local function closeConnection( )
		if db and db:isopen() then
			db:close()
		end     
	end
	 
	--Handle the applicationExit event to close the db
	local function onSystemEvent( event )
	    if( event.type == "applicationExit" ) then              
	        closeConnection()
	    end
	end

    -- Find substring
    function findLast(haystack, needle)
        local i=haystack:match(".*"..needle.."()")
        if i==nil then return -1 else return i-1 end
    end

	--obtiene los datos del admin
	dbManager.getSettings = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM config;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end
	
	--obtiene los datos de los guardias
	dbManager.getGuards = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM empleados;") do
			result[#result + 1] = row
		end
		closeConnection( )
		if #result > 0 then
			return result
		else
			return 1
		end
	end
	
	--obtiene los datos del guardia activo
	dbManager.getGuardActive = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM empleados where active = 1;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end
	
	--obtiene los datos del guardia activo
	dbManager.getCondominiums = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM condominios;") do
			result[#result + 1] = row
		end
		closeConnection( )
		if #result > 0 then
			return result
		else
			return 1
		end
	end
	
	--obtiene los datos de registro visitante por id
	dbManager.getRecordVisitById = function(id)
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM registro_visitas where id = '" .. id .. "' ;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end

	--valida el acceso de un guardia
	dbManager.validateGuard = function(password, idG)
		local crypto = require("crypto")
		local pass = crypto.digest(crypto.md5, password)
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM empleados where id = '" .. idG .. "' and contrasena = '" .. pass .."';") do
			local query = "UPDATE empleados SET active = 1 where id = " .. row.id ..";"
			db:exec( query )
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end
	
	--activa un guardia
	dbManager.updateGuardActive = function()
		openConnection( )
		local query = "UPDATE empleados SET active = 0;"
        db:exec( query )
		closeConnection( )
	end
	
	--actualiza los datos del admin
    dbManager.updateUser = function(idApp, email, password, name, city, residencial)
		openConnection( )
        local query = "UPDATE config SET idApp = "..idApp..", email = '"..email.."', name = '"..name.."', city = '"..city.."', residencial = '"..residencial.."';"
        db:exec( query )
		closeConnection( )
	end
	
	--actualiza los datos del admin
    dbManager.updateMessageGuard = function(items)
		openConnection( )
        local query = "UPDATE cat_notificaciones_seguridad SET idMSG = "..items.idMSGNew..", enviado = '1' where id = '" .. items.idMSG .. "' ;"
        db:exec( query )
		closeConnection( )
	end
	
	--actualiza los datos del admin
    dbManager.updateRecordVisit = function(items)
		openConnection( )
        local query = "UPDATE registro_visitas SET idRV = "..items.idMSGNew..", enviado = '1' where id = '" .. items.idMSG .. "' ;"
        local result = db:exec( query )
		closeConnection( )
		return result
	end
	
	--inserta los guardias de la residencial
	dbManager.insertGuard = function(items)
		openConnection( )
			for i = 1, #items, 1 do
				local query = "INSERT INTO empleados VALUES ('" .. items[i].id .."', '" .. items[i].nombre .."', '" .. items[i].contrasena .."', '" .. items[i].foto .."', '0');"
				db:exec( query )
			end
		closeConnection( )
	end
	
	--inserta los datos del condominio
	dbManager.insertCondominium = function(items)
		openConnection( )
			for i = 1, #items, 1 do
				local query = "INSERT INTO condominios VALUES ('" .. items[i].id .."', '" .. items[i].nombre .."');"
				db:exec( query )
			end
		closeConnection( )
	end
	
	--guarda el mensaje antes de ser enviado
	dbManager.saveMessageGuard = function(subject,message,dateTime)
	
		local settingsGuard = dbManager.getGuardActive()
		openConnection( )
		
		local idMSG = 1
		
		local query = "INSERT INTO cat_notificaciones_seguridad (idMSG, empleadosId, asunto, mensaje, fechaHora, enviado) VALUES ('0', '" .. settingsGuard.id .."', '" .. subject .."', '" .. message .."', '" .. dateTime .."', '0');"
		db:exec( query )
		
		closeConnection( )
	end
	
	--guarda el mensaje antes de ser enviado
	dbManager.saveRecordVisit = function(subject,message,idCondominius,dateTime, imagen)
	
		local settingsGuard = dbManager.getGuardActive()
		local nameImage1 = imagen .. 1 .. settingsGuard.id .. ".jpg"
		local nameImage2 = imagen .. 2 .. settingsGuard.id .. ".jpg"
		
		print('nameImage3 ' .. nameImage1)
		openConnection( )
		
		local idMSG = 1
		
		local query = "INSERT INTO registro_visitas (idRV, empleadosId, nombreVisitante, motivo, idFrente, idVuelta, condominiosId, fechaHora, enviado) VALUES ('0', '" .. settingsGuard.id .."', '" .. subject .."', '" .. message .."', '" .. nameImage1 .."', '" .. nameImage2 .."', '" .. idCondominius .."', '" .. dateTime .."', '0');"
		db:exec( query )
		
		local idRV = db:last_insert_rowid()
		
		closeConnection( )
		
		return idRV
	end
	
	--obtiene los mensajes no guardados
	dbManager.getMessageUnsent = function(typeMSG)
		local result = {}
		openConnection( )
		if typeMSG == 1 then
			for row in db:nrows("SELECT * FROM cat_notificaciones_seguridad where enviado = 0;") do
				result[#result + 1] = row
			end
		else
			for row in db:nrows("SELECT * FROM registro_visitas where enviado = 0;") do
				result[#result + 1] = row
			end
		end
		
		closeConnection( )
		if #result > 0 then
			return result
		else
			return 1
		end
	end
	
	
	--limpia la tabla de admin, guardia y condominio
    dbManager.clearUser = function()
        openConnection( )
        query = "UPDATE config SET idApp = 0, email = '', password = '', name = '', city = '', residencial = '';"
        db:exec( query )
		query = "delete from empleados;"
        db:exec( query )
		query = "delete from condominios;"
        db:exec( query )
		closeConnection( )
    end

	--Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idApp INTEGER, email TEXT, password TEXT, name TEXT, "..
					" city INTEGER, residencial INTEGER, url TEXT );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS empleados (id INTEGER, nombre TEXT, contrasena TEXT, foto TEXT, "..
					" active INTEGER );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS condominios (id INTEGER, nombre TEXT );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS cat_notificaciones_seguridad (id INTEGER PRIMARY KEY AUTOINCREMENT, idMSG INTEGER, empleadosId INTEGER, asunto TEXT, mensaje TEXT, fechaHora TEXT, enviado INTEGER );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS registro_visitas (id INTEGER PRIMARY KEY AUTOINCREMENT, idRV INTEGER, empleadosId INTEGER, nombreVisitante TEXT, motivo TEXT," ..
		"idFrente TEXT, idVuelta TEXT, condominiosId INTEGER, fechaHora TEXT, enviado INTEGER );"
		db:exec( query )

        -- Return if have connection
		for row in db:nrows("SELECT idApp FROM config;") do
            closeConnection( )
            if row.idApp == 0 then
                return false
            else
                return true
            end
		end
		
        -- Populate config
		query = "INSERT INTO config VALUES (1, 0, '', '', '', '', '', 'http://geekbucket.com.mx/booking/');"
		--query = "INSERT INTO config VALUES (1, 0, '', '', '', '', '', 'http://localhost:8080/booking/');"
		
		db:exec( query )
    
		closeConnection( )
    
        return false
	end
	

	--setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )
    

return dbManager