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

fontDefault = native.systemFont

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
	composer.removeScene("src.LoginGuard")
	composer.gotoScene("src.LoginGuard")
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
	bgNotification:setFillColor( 222/255, 222/255, 222/255 )
	notificationScreen:insert(bgNotification)
	
	local imgLogo = display.newCircle( intW/2, h + 110, 90 )
	imgLogo:setFillColor( 1 )
	notificationScreen:insert(imgLogo)
	
	local bgfringeDown = display.newRect( 0, intH - 20, intW, 20 )
	bgfringeDown.anchorX = 0
	bgfringeDown.anchorY = 0
	bgfringeDown:setFillColor( 96/255, 96/255, 96/255 )
	notificationScreen:insert(bgfringeDown)
	
	local bgfringeField = display.newRect( 0, h + 220, intW, 400 )
	bgfringeField.anchorX = 0
	bgfringeField.anchorY = 0
	bgfringeField:setFillColor( 54/255, 80/255, 131/255 )
	notificationScreen:insert(bgfringeField)
	
	local lastY = intH/2 - 85
	
	labelMsgConfirmation = display.newText( {   
        x = intW/2, y = lastY,
        text = "LA VISITA HA SIDO REGISTRADA",  font = fontDefault, fontSize = 44
	})
	labelMsgConfirmation:setFillColor( 1 )
	notificationScreen:insert(labelMsgConfirmation)
	
	lastY = intH/2 - 40
	
	local labelMsgNotiConfirm = display.newText( {   
        x = intW/2, y = lastY,
        text = "SE HA NOTIFICADO AL CONDOMINIO MEDIANTE MENSAJE A SU APLICACION",  font = fontDefault, fontSize = 22
	})
	labelMsgNotiConfirm:setFillColor( 1 )
	notificationScreen:insert(labelMsgNotiConfirm)
	
	local bgNotiMSG = display.newRoundedRect( intW/2, lastY + 30, 600, 270, 10 )
	bgNotiMSG.anchorY = 0
	bgNotiMSG:setFillColor( 1 )
	notificationScreen:insert(bgNotiMSG)
	
	labelMsgDate = display.newText( {   
        x = intW/2, y = lastY + 50,
		width = 560,
        text = "09 de septiembre del 2015 05:57 pm",  font = fontDefault, fontSize = 22, align = "right",
	})
	labelMsgDate:setFillColor( 64/255, 90/255, 139/255 )
	notificationScreen:insert(labelMsgDate)
	
	labelMsgNameVisit = display.newText( {   
        x = intW/2, y = lastY + 100,
		width = 560,
        text = "VISITANTE: ",  font = fontDefault, fontSize = 24
	})
	labelMsgNameVisit:setFillColor( 64/255, 90/255, 139/255 )
	notificationScreen:insert(labelMsgNameVisit)
	
	labelMsgReasonVisit = display.newText( {   
        x = intW/2, y = lastY + 150,
		width = 560,
        text = "MOTIVO DE VISITA: ",  font = fontDefault, fontSize = 24
	})
	labelMsgReasonVisit:setFillColor( 64/255, 90/255, 139/255 )
	notificationScreen:insert(labelMsgReasonVisit)
	
	labelMsgMessageVisit = display.newText( {   
        x = intW/2, y = lastY + 205,
		width = 560,
        text = "MENSAJE: ",  font = fontDefault, fontSize = 24
	})
	labelMsgMessageVisit:setFillColor( 64/255, 90/255, 139/255 )
	notificationScreen:insert(labelMsgMessageVisit)
	
	btnMsgContinue = display.newRoundedRect( intW/2, intH - 65, 200, 65, 10 )
	btnMsgContinue:setFillColor( 64/255, 90/255, 139/255 )
	notificationScreen:insert(btnMsgContinue)
	btnMsgContinue:addEventListener( 'tap', returnHomeMsg )
	
	local labelMsgContinue = display.newText( {   
        x = intW/2, y = intH - 65,
        text = "ACEPTAR",  font = fontDefault, fontSize = 28
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