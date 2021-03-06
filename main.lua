-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Geek Bucket
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require( "composer" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
--

display.setStatusBar( display.DarkStatusBar )

local isUser = DBManager.setupSquema()

local RestManager = require('src.resources.RestManager')

function createFolderPhoto(name)
	
	local lfs = require( "lfs" )

	-- Get raw path to documents directory
	local docs_path = system.pathForFile( "", system.TemporaryDirectory )

	-- Change current working directory
	local success = lfs.chdir( docs_path )  -- Returns true on success

	local new_folder_path
	local dname = name

	if ( success ) then
		lfs.mkdir( dname )
		new_folder_path = lfs.currentdir() .. "/" .. dname
	end
	
end

function DidReceiveRemoteNotification(message, additionalData, isActive)
    if isActive then
		system.vibrate()
        reloadPanel()
	else
		--reloadPanel()
	end
end

local OneSignal = require("plugin.OneSignal")
OneSignal.Init("d5a06f1e-b4c1-424a-8964-52458c9045a6", 585019552300, DidReceiveRemoteNotification)

function IdsAvailable(userID, pushToken)
    Globals.playerIdToken = userID
end
OneSignal.IdsAvailableCallback(IdsAvailable)
OneSignal.EnableNotificationsWhenActive(true)

createFolderPhoto('fotos')
createFolderPhoto('tempFotos')

if not isUser then
	composer.gotoScene( "src.Login" )
else
	--composer.gotoScene( "src.Login" )
	composer.gotoScene("src.LoginGuard")
	--composer.gotoScene("src.Home")
end



timeMarker = timer.performWithDelay( 30000, function()
	if Globals.ItIsUploading == 0 then
		RestManager.checkUnsentMessage(1)
	end
end, -1 )