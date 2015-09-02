-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Envio de mensaje
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

--variables
local notificationScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"

----elementos

local labelMsgConfirmation
local labelMsgNameVisit
local labelMsgReasonVisit
local labelMsgDateVisit
	
local btnMsgContinue

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------
	
--regresa al menu de home
function returnHomeMsg( event )
	composer.gotoScene("src.Home")
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(notificationScreen)
	
	local bgNotification = display.newRect( 0, h, intW, intH )
	bgNotification.anchorX = 0
	bgNotification.anchorY = 0
	bgNotification:setFillColor( 214/255, 226/255, 225/255 )
	notificationScreen:insert(bgNotification)
	
	local imgLogo = display.newRect( intW/2, h + 100, 150, 150 )
	imgLogo:setFillColor( 0 )
	notificationScreen:insert(imgLogo)
	
	local lastY = intH/2 - 75
	
	labelMsgConfirmation = display.newText( {   
        x = intW/2, y = lastY,
        text = "La visita ha sido registrada",  font = fontDefault, fontSize = 32
	})
	labelMsgConfirmation:setFillColor( 0 )
	notificationScreen:insert(labelMsgConfirmation)
	
	lastY = intH/2 - 25
	
	local labelMsgNotiConfirm = display.newText( {   
        x = intW/2, y = lastY,
        text = "Se ha notificado al condominio mediante mensaje a su aplicación",  font = fontDefault, fontSize = 28
	})
	labelMsgNotiConfirm:setFillColor( 0 )
	notificationScreen:insert(labelMsgNotiConfirm)
	
	labelMsgNameVisit = display.newText( {   
        x = intW/2, y = lastY + 90,
		width = intW - intW/2.7,
        text = "Visitante: ",  font = fontDefault, fontSize = 32
	})
	labelMsgNameVisit:setFillColor( 0 )
	notificationScreen:insert(labelMsgNameVisit)
	
	labelMsgReasonVisit = display.newText( {   
        x = intW/2, y = lastY + 150,
		width = intW - intW/2.7,
        text = "Motivo de la visita : ",  font = fontDefault, fontSize = 32
	})
	labelMsgReasonVisit:setFillColor( 0 )
	notificationScreen:insert(labelMsgReasonVisit)
	
	labelMsgDateVisit = display.newText( {   
        x = intW/2, y = lastY + 215,
		width = intW - intW/2.7,
        text = "Fecha y hora registrada : ",  font = fontDefault, fontSize = 32
	})
	labelMsgDateVisit:setFillColor( 0 )
	notificationScreen:insert(labelMsgDateVisit)
	
	btnMsgContinue = display.newRect( intW/2, intH - 80, 300, 65 )
	btnMsgContinue:setFillColor( .2 )
	notificationScreen:insert(btnMsgContinue)
	btnMsgContinue:addEventListener( 'tap', returnHomeMsg )
	
	local labelMsgContinue = display.newText( {   
        x = intW/2, y = intH - 80,
        text = "Continuar",  font = fontDefault, fontSize = 28
	})
	labelMsgContinue:setFillColor( 1 )
	notificationScreen:insert(labelMsgContinue)
   
end

-- "scene:show()"
function scene:show( event )
	
end

-- "scene:hide()"
function scene:hide( event )
	--local phase = event.phase
   --phase == "will"
   --phase == "did"
end

-- "scene:destroy()"
function scene:destroy( event )
	
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene