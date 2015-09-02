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
local messageAdminScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"

----elementos
local txtMsgMessage
local txtMsgSubject

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------
	
--envia el mensaje al administrador
function sendMessageToadmin( event )
	native.showAlert( "Booking", "Mensaje enviado", { "OK"})
	composer.gotoScene("src.Home")
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
	bgSendMessage:setFillColor( 214/255, 226/255, 225/255 )
	messageAdminScreen:insert(bgSendMessage)
	
	local imgLogo = display.newRect( intW/2, h + 100, 150, 150 )
	imgLogo:setFillColor( 0 )
	messageAdminScreen:insert(imgLogo)
	
	------campos asunto
	
	lastY = intH/2.3
	
	local labelMsgSubject = display.newText( {   
        x = intW/2 - 150, y = lastY,
		width = 200,
        text = "Asunto:",  font = fontDefault, fontSize = 32
	})
	labelMsgSubject:setFillColor( 0 )
	messageAdminScreen:insert(labelMsgSubject)
	
	local bgTextFieldMsgSubject = display.newRect( intW/2 + 85, lastY, 350, 60 )
	bgTextFieldMsgSubject:setFillColor( 1 )
	messageAdminScreen:insert(bgTextFieldMsgSubject)
	
	txtMsgSubject = native.newTextField( intW/2 + 85, lastY, 350, 60 )
    txtMsgSubject.inputType = "email"
    txtMsgSubject.hasBackground = false
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtMsgSubject.size = 20
	messageAdminScreen:insert(txtMsgSubject)
	
	------campo mensaje
	
	lastY = intH/1.9
	
	local labelMsgMessage = display.newText( {   
        x = intW/2 - 150, y = lastY,
		width = 200,
        text = "Mensaje:",  font = fontDefault, fontSize = 32
	})
	labelMsgMessage:setFillColor( 0 )
	messageAdminScreen:insert(labelMsgMessage)
	
	lastY = intH/1.45
	
	local bgTextBoxdMsgMessage = display.newRect( intW/2 + 5, lastY, 510, 180 )
	bgTextBoxdMsgMessage:setFillColor( 1 )
	messageAdminScreen:insert(bgTextBoxdMsgMessage)
	
	txtMsgMessage = native.newTextBox( intW/2 + 5, lastY, 510, 180 )
	txtMsgMessage.isEditable = true
	txtMsgMessage.hasBackground = false
	txtMsgMessage.size = 20
	messageAdminScreen:insert(txtMsgMessage)
	
	-----botones---
	
	lastY = intH/1.2
	lastY = intH/1.12
	
	local btnCancelSendMessage = display.newRect( intW/2 - 120, lastY, 200, 65 )
	btnCancelSendMessage:setFillColor( 1, 0, 0 )
	messageAdminScreen:insert(btnCancelSendMessage)
	btnCancelSendMessage:addEventListener( 'tap', returnHomeMSGAdmin )
	
	local labelCancelSendMessage = display.newText( {   
        x = intW/2 - 120, y = lastY,
        text = "Cancelar",  font = fontDefault, fontSize = 28
	})
	labelCancelSendMessage:setFillColor( 1 )
	messageAdminScreen:insert(labelCancelSendMessage)
	
	local btnSendMessage = display.newRect( intW/2 + 120, lastY, 200, 65 )
	btnSendMessage:setFillColor( 0, 0, 1 )
	messageAdminScreen:insert(btnSendMessage)
	btnSendMessage:addEventListener( 'tap', sendMessageToadmin)
	
	local labelSendMessage = display.newText( {   
        x = intW/2 + 120, y = lastY,
        text = "Aceptar",  font = fontDefault, fontSize = 28
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