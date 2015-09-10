-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Geek Bucket
-----------------------------------------------------------------------------------------

-- Your code here

local DBManager = require('src.resources.DBManager')
local composer = require( "composer" )

display.setStatusBar( display.DarkStatusBar )

local isUser = DBManager.setupSquema()

if not isUser then
	composer.gotoScene( "src.Login" )
else
	composer.gotoScene( "src.Login" )
	--composer.gotoScene("src.LoginGuard")
	--composer.gotoScene("src.Home")
end