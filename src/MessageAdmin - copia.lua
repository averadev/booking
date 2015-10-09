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
local messageAdminField = display.newGroup()

local messageMessage = display.newGroup()
local messageSubject = display.newGroup()
local messageAdminBtn = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

----elementos
local txtMsgMessage
local txtMsgSubject

local labelWelcomeMsgAdmin

fontDefault = native.systemFont
local fontLatoBold, fontLatoLight, fontLatoRegular
local environment = system.getInfo( "environment" )
if environment == "simulator" then
	fontLatoBold = native.systemFontBold
	fontLatoLight = native.systemFont
	fontLatoRegular = native.systemFont
else
	fontLatoBold = "Lato-Bold"
	fontLatoLight = "Lato-Light"
	fontLatoRegular = "Lato-Regular"
end

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
		local msgError = "Por favor Introduce los siguientes datos faltantes: "
		if txtMsgMessage.text == "" then
			msgError = msgError .. "\n*Asunto "
		end
		if txtMsgSubject.text == "" then
			msgError = msgError .. "\n*Mensaje "
		end
		NewAlert("Datos Faltantes", msgError, 1)
	end
end

--regresa al pantalla de home
function returnHomeMSGAdmin( event )
	composer.gotoScene("src.Home")
end

function onTxtFocusMSGAdmin( event )

	--[[messageMessage
	messageSubject
	messageAdminBtn]]
	
	if ( event.phase == "began" ) then
		labelWelcomeMsgAdmin.y = h + 30
		messageAdminField.y = -110
		messageMessage.y = - 150
		messageSubject.y = - 170
		messageAdminBtn.y = - 190

    elseif ( event.phase == "ended" ) then
		native.setKeyboardFocus( nil )
		labelWelcomeMsgAdmin.y = h + 100
		messageAdminField.y = 0
		messageMessage.y = 0
		messageSubject.y = 0
		messageAdminBtn.y = 0
    elseif ( event.phase == "submitted" ) then
		native.setKeyboardFocus( nil )
		labelWelcomeMsgAdmin.y = h + 100
		messageAdminField.y = 0
		messageMessage.y = 0
		messageSubject.y = 0
		messageAdminBtn.y = 0

    elseif event.phase == "editing" then
		
    end
	
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(messageAdminScreen)
	screen:insert(messageAdminField)
	
	screen:insert(messageMessage)
	screen:insert(messageSubject)
	screen:insert(messageAdminBtn)
	
	local bgSendMessage = display.newImage( "img/btn/fondo.png" )
	bgSendMessage.anchorX = 0
	bgSendMessage.anchorY = 0
	bgSendMessage.width = intW
	bgSendMessage.height = intH - h
	bgSendMessage.y = h
	messageAdminScreen:insert(bgSendMessage)
	
	local imgArrowBack = display.newImage( "img/btn/seleccionOpcion-regresarSuperior.png" )
	imgArrowBack.x = 30
	imgArrowBack.y = h + 40
	messageAdminScreen:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnHomeMSGAdmin)
	
	local labelArrowBack = display.newText( {   
        x = 125, y = h + 40,
        text = "REGRESAR",  font = fontLatoBold, fontSize = 26
	})
	labelArrowBack:setFillColor( 1 )
	messageAdminScreen:insert(labelArrowBack)
	labelArrowBack:addEventListener( 'tap', returnHomeMSGAdmin)
	
	labelWelcomeMsgAdmin = display.newText( {   
        x = intW/2, y = h + 100, 
        text = "Envío de mensaje a administración",  font = fontLatoRegular, fontSize = 36
	})
	labelWelcomeMsgAdmin:setFillColor( 1 )
	messageAdminScreen:insert(labelWelcomeMsgAdmin)
	
	local bgImgGuard = display.newRoundedRect( intW/2, h + 180, 650, 450, 5 )
	bgImgGuard.anchorY = 0
	bgImgGuard:setFillColor( 6/255, 58/255, 98/255 )
	bgImgGuard.strokeWidth = 4
	bgImgGuard:setStrokeColor( 54/255, 80/255, 131/255 )
	messageAdminField:insert(bgImgGuard)
	
	------campos asunto
	
	lastY = 300
	
	local bgTextFieldMsgSubject = display.newRoundedRect( intW/2, lastY, 550, 60, 10 )
	bgTextFieldMsgSubject:setFillColor( 1 )
	messageMessage:insert(bgTextFieldMsgSubject)
	
	txtMsgSubject = native.newTextField( intW/2, lastY, 550, 60 )
    txtMsgSubject.inputType = "email"
    txtMsgSubject.hasBackground = false
	txtMsgSubject.placeholder = "ASUNTO"
	txtMsgSubject:addEventListener( "userInput", onTxtFocusMSGAdmin )
	--txtSignEmail:setReturnKey( "next" )
	txtMsgSubject.size = 20
	messageMessage:insert(txtMsgSubject)
	
	------campo mensaje
	
	lastY = lastY + 150
	
	local bgTextBoxdMsgMessage = display.newRoundedRect( intW/2, lastY, 550, 120, 10 )
	bgTextBoxdMsgMessage:setFillColor( 1 )
	messageSubject:insert(bgTextBoxdMsgMessage)
	
	txtMsgMessage = native.newTextBox( intW/2, lastY, 550, 120 )
	txtMsgMessage.isEditable = true
	txtMsgMessage.hasBackground = false
	txtMsgMessage.placeholder = "MENSAJE"
	txtMsgMessage:addEventListener( "userInput", onTxtFocusMSGAdmin )
	txtMsgMessage.size = 20
	messageSubject:insert(txtMsgMessage)
	
	-----botones---
	
	lastY = lastY + 155
	
	local paint = {
		type = "gradient",
		color1 = { 49/255, 187/255, 40/255 },
		color2 = { 45/255, 161/255, 45/255, 0.9 },
		direction = "down"
	}
	
	btnSendMessage = display.newRoundedRect( intW/2, lastY, 200, 70, 10 )
	btnSendMessage:setFillColor( 205/255, 69/255, 69/255 )
	messageAdminBtn:insert(btnSendMessage)
	btnSendMessage.fill = paint
	btnSendMessage:addEventListener( 'tap', sendMessageToadmin)
	
	labelSendMessage = display.newText( {   
        x = intW/2, y = lastY,
        text = "ENVIAR",  font = fontLatoRegular, fontSize = 28
	})
	labelSendMessage:setFillColor( 1 )
	messageAdminBtn:insert(labelSendMessage)
   
end

-- "scene:show()"
function scene:show( event )
end

-- "scene:hide()"
function scene:hide( event )
	native.setKeyboardFocus( nil )
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