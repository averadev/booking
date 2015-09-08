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

    dbManager.updateUser = function(idApp, email, password, name, city, residencial)
		openConnection( )
        local query = "UPDATE config SET idApp = "..idApp..", email = '"..email.."', name = '"..name.."', city = '"..city.."', residencial = '"..residencial.."';"
        db:exec( query )
		closeConnection( )
	end

    dbManager.clearUser = function()
        openConnection( )
        query = "UPDATE config SET idApp = 0, email = '', password = '', name = '', city = '', residencial = '';"
        db:exec( query )
		closeConnection( )
    end

	--Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idApp INTEGER, email TEXT, password TEXT, name TEXT, "..
					" city INTEGER, residencial INTEGER, url TEXT );"
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
		query = "INSERT INTO config VALUES (1, 0, '', '', '', '', '', 'http://booking');"
		
		db:exec( query )
    
		closeConnection( )
    
        return false
	end
	

	--setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )
    

return dbManager