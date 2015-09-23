-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Envio de mensaje
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
local Globals = require('src.resources.Globals')
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

--variables
local messageAdminScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont

----elementos
local txtMsgMessage
local txtMsgSubject

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

function goToLoginGuardMSGAdmin()

		composer.removeScene("src.LoginGuard")
		composer.gotoScene("src.LoginGuard")

end
	
--envia el mensaje al administrador
function sendMessageToadmin( event )
	
	if txtMsgMessage.text ~= '' and txtMsgSubject.text ~= '' then
		NewAlert("Enviando mensaje", 600, 200)
		local dateS2 = RestManager.getDate()
		
		DBManager.saveMessageGuard(txtMsgMessage.text, txtMsgSubject.text, dateS2)
		--DBManager.saveMessageGuard("Bienvenida", "Mensaje de bienbenida", dateS2)
		RestManager.sendMessagesGuard()
	else
		NewAlert("Campos vacios.", 600, 200)
		timeMarker = timer.performWithDelay( 2000, function()
			deleteNewAlert()
		end, 1 )
	end
end

--regresa al pantalla de home
function returnHomeMSGAdmin( event )
	composer.gotoScene("src.Home")
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(messageAdminScreen)
	
	local bgSendMessage = display.newRect( 0, h, intW, intH )
	bgSendMessage.anchorX = 0
	bgSendMessage.anchorY = 0
	bgSendMessage:setFillColor( 222/255, 222/255, 222/255 )
	messageAdminScreen:insert(bgSendMessage)
	
	local imgLogo = display.newCircle( intW/2, h + 110, 90 )
	imgLogo:setFillColor( 1 )
	messageAdminScreen:insert(imgLogo)
	
	local bgfringeDown = display.newRect( 0, intH - 20, intW, 20 )
	bgfringeDown.anchorX = 0
	bgfringeDown.anchorY = 0
	bgfringeDown:setFillColor( 96/255, 96/255, 96/255 )
	messageAdminScreen:insert(bgfringeDown)
	
	local bgfringeField = display.newRect( 0, h + 250, intW, 270 )
	bgfringeField.anchorX = 0
	bgfringeField.anchorY = 0
	bgfringeField:setFillColor( 54/255, 80/255, 131/255 )
	messageAdminScreen:insert(bgfringeField)
	
	------campos asunto
	
	lastY = intH/2.2
	
	local bgTextFieldMsgSubject = display.newRoundedRect( intW/2 - 80, lastY, 350, 60, 10 )
	bgTextFieldMsgSubject:setFillColor( 1 )
	messageAdminScreen:insert(bgTextFieldMsgSubject)
	
	txtMsgSubject = native.newTextField( intW/2 - 80, lastY, 350, 60 )
    txtMsgSubject.inputType = "email"
    txtMsgSubject.hasBackground = false
	txtMsgSubject.placeholder = "ASUNTO"
	--txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey( "next" )
	txtMsgSubject.size = 20
	messageAdminScreen:insert(txtMsgSubject)
	
	------campo mensaje
	
	lastY = intH/1.6
	
	local bgTextBoxdMsgMessage = display.newRoundedRect( intW/2, lastY, 510, 120, 10 )
	bgTextBoxdMsgMessage:setFillColor( 1 )
	messageAdminScreen:insert(bgTextBoxdMsgMessage)
	
	txtMsgMessage = native.newTextBox( intW/2, lastY, 510, 120 )
	txtMsgMessage.isEditable = true
	txtMsgMessage.hasBackground = false
	txtMsgMessage.placeholder = "MENSAJE"
	txtMsgMessage.size = 20
	messageAdminScreen:insert(txtMsgMessage)
	
	-----botones---
	
	lastY = 600 + h
	
	local imgArrowBack = display.newImage( "img/btn/REGRESAR.png" )
	imgArrowBack.x = 50
	imgArrowBack.height = 50
	imgArrowBack.width = 50
	imgArrowBack.y = h + 40
	messageAdminScreen:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnHomeMSGAdmin)
	
	local labelArrowBack = display.newText( {   
        x = 140, y = h + 40,
        text = "REGRESAR",  font = fontDefault, fontSize = 18
	})
	labelArrowBack:setFillColor( 64/255, 90/255, 139/255 )
	messageAdminScreen:insert(labelArrowBack)
	
	local btnSendMessage = display.newRoundedRect( intW/2, lastY, 200, 70, 10 )
	btnSendMessage:setFillColor( 205/255, 69/255, 69/255 )
	messageAdminScreen:insert(btnSendMessage)
	btnSendMessage:addEventListener( 'tap', sendMessageToadmin)
	
	local labelSendMessage = display.newText( {   
        x = intW/2, y = lastY,
        text = "ACEPTAR",  font = fontDefault, fontSize = 28
	})
	labelSendMessage:setFillColor( 1 )
	messageAdminScreen:insert(labelSendMessage)
   
end

-- "scene:show()"
function scene:show( event )
	
end

-- "scene:hide()"
function scene:hide( event )
	
	if txtMsgMessage then
		txtMsgMessage:removeSelf()
		txtMsgMessage = nil
		txtMsgSubject:removeSelf()
		txtMsgSubject = nil
	end
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