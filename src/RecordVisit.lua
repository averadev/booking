-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Registrio de visitas
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
local composer = require( "composer" )
local widget = require( "widget" )
local Globals = require('src.resources.Globals')
local scene = composer.newScene()

--variables
local recordVisitScreen = display.newGroup()
local grpTextFieldRV = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"

----elementos
local txtRecordVisitName
local txtRecordVisitReason
local txtRecordNumCondo

local photoFrontal = nil
local photoBack = nil
local typePhoto = 0

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------
	
--envia el mensaje al administrador
function sendMessageToadmin( event )
	native.showAlert( "Booking", "Mensaje enviado", { "OK"})
	composer.gotoScene("src.Home")
end

--muestra la pantalla de condominio
function showListCondominium( event )
	composer.gotoScene("src.ListCondominium")
end

--regresa a la pantalla de home
function returnHomeRecordVisit( event )
	composer.gotoScene("src.Home")
end

--envia el mensaje
function sendRecordVisit( event )
	composer.gotoScene("src.Notification")
end

--camara
function takePhotography( event )

	typePhoto = event.target.type
	
	local function onComplete( event )
		--local photo = event.target
		--[[photo.height = 150
		photo.width = 200
		photo.x = 100
		photo.y = intH/2.04]]
		
		if typePhoto == 1 then
			if photoFrontal then
				photoFrontal:removeSelf()
				photoFrontal = nil
			end
			photoFrontal = event.target
			photoFrontal.height = 150
			photoFrontal.width = 200
			photoFrontal.x = intW/1.65
			photoFrontal.y = intH/2.04
			recordVisitScreen:insert(photoFrontal)
			
		else
		
			if photoBack then
				photoBack:removeSelf()
				photoBack = nil
			end
			photoBack =  event.target
			photoBack.height = 150
			photoBack.width = 200
			photoBack.x = intW/1.18
			photoBack.y = intH/2.04
			recordVisitScreen:insert(photoBack)
		
		end
		
	end

	if media.hasSource( media.Camera ) then
		media.capturePhoto( { listener=onComplete } )
	else
		native.showAlert( "Corona", "This device does not have a camera.", { "OK" } )
	end
	
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(recordVisitScreen)
	--screen:insert(grpTextFieldRV)
	
	
	local bgRecordVisit = display.newRect( 0, h, intW, intH )
	bgRecordVisit.anchorX = 0
	bgRecordVisit.anchorY = 0
	bgRecordVisit:setFillColor( 222/255, 222/255, 222/255 )
	recordVisitScreen:insert(bgRecordVisit)
	
	local imgLogo = display.newCircle( intW/3, h + 115, 90 )
	imgLogo:setFillColor( 1 )
	recordVisitScreen:insert(imgLogo)
	
	local bgfringeDown = display.newRect( 0, intH - 20, intW, 20 )
	bgfringeDown.anchorX = 0
	bgfringeDown.anchorY = 0
	bgfringeDown:setFillColor( 96/255, 96/255, 96/255 )
	recordVisitScreen:insert(bgfringeDown)
	
	local bgfringeField = display.newRect( 0, intH - 490, intW, 470 )
	bgfringeField.anchorX = 0
	bgfringeField.anchorY = 0
	bgfringeField:setFillColor( 54/255, 80/255, 131/255 )
	recordVisitScreen:insert(bgfringeField)
	
	local imgArrowBack = display.newImage( "img/btn/REGRESAR.png" )
	imgArrowBack.x = 50
	imgArrowBack.height = 50
	imgArrowBack.width = 50
	imgArrowBack.y = h + 40
	recordVisitScreen:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnHomeRecordVisit)
	
	local labelArrowBack = display.newText( {   
        x = 140, y = h + 40,
        text = "REGRESAR",  font = fontDefault, fontSize = 18
	})
	labelArrowBack:setFillColor( 64/255, 90/255, 139/255 )
	recordVisitScreen:insert(labelArrowBack)
	
	local imgGuardTurn = display.newRoundedRect( intW/1.3, h + 105, 150, 150, 10 )
	imgGuardTurn:setFillColor( 1 )
	recordVisitScreen:insert(imgGuardTurn)
	
	local imgGuardTurn = display.newImage( Globals.photoGuard, system.TemporaryDirectory )
	imgGuardTurn.x = intW/1.3
	imgGuardTurn.height = 100
	imgGuardTurn.width = 100
	imgGuardTurn.y = h + 90
	recordVisitScreen:insert(imgGuardTurn)
	
	local labelGuardTurn = display.newText( {   
        x = intW/1.3, y = h + 155,
        text = Globals.nameGuard,  font = fontDefault, fontSize = 20
	})
	labelGuardTurn:setFillColor( 64/255, 90/255, 139/255 )
	recordVisitScreen:insert(labelGuardTurn)
	
	local lineRecordVisit = display.newLine( intW/2, 330, intW/2, intH - 150 )
	lineRecordVisit:setStrokeColor( 1 )
	lineRecordVisit.strokeWidth = 4
	recordVisitScreen:insert(lineRecordVisit)
	
	---- campo nombre del visitante
	
	lastY = intH/2.1
	
	local bgTextRecordVisitName = display.newRoundedRect( intW/4, lastY, 400, 60, 10 )
	bgTextRecordVisitName:setFillColor( 1 )
	recordVisitScreen:insert(bgTextRecordVisitName)
	
	txtRecordVisitName = native.newTextField( intW/4, lastY, 400, 60 )
    txtRecordVisitName.inputType = "email"
    txtRecordVisitName.hasBackground = false
	txtRecordVisitName.placeholder = "ASUNTO"
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtRecordVisitName.size = 20
	grpTextFieldRV:insert(txtRecordVisitName)
	
	---- campo motivo del visitante
	
	lastY = intH/1.6
	
	local bgTextRecordVisitReason = display.newRoundedRect( intW/4, lastY, 400, 120, 10 )
	bgTextRecordVisitReason:setFillColor( 1 )
	recordVisitScreen:insert(bgTextRecordVisitReason)
	
	txtRecordVisitReason = native.newTextBox( intW/4, lastY, 400, 120 )
    txtRecordVisitReason.hasBackground = false
	txtRecordVisitReason.isEditable = true
	txtRecordVisitReason.placeholder = "Nombre del visitante"
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtRecordVisitReason.size = 24
	grpTextFieldRV:insert(txtRecordVisitReason)
	
	----- campo num. condominio
	
	lastY = intH/1.3
	
	local bgTextRecordNumCondo = display.newRoundedRect( intW/4, lastY, 400, 60, 10 )
	bgTextRecordNumCondo:setFillColor( 1 )
	recordVisitScreen:insert(bgTextRecordNumCondo)
	
	local imgNumCondo = display.newImage( "img/btn/optionCondo.png" )
	imgNumCondo.x = intW/4 + 170
	imgNumCondo.y = lastY
	imgNumCondo.height = 35
	imgNumCondo.width = 40
	recordVisitScreen:insert(imgNumCondo)
	imgNumCondo:addEventListener( 'tap', showListCondominium)
	
	txtRecordNumCondo = native.newTextField( intW/4 - 30, lastY, 340, 60 )
    txtRecordNumCondo.inputType = "number"
    txtRecordNumCondo.hasBackground = false
	txtRecordNumCondo.placeholder = "SELECCIONAR CONDOMINIO"
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtRecordNumCondo.size = 20
	grpTextFieldRV:insert(txtRecordNumCondo)
	
	----- fotos -----
	
	lastY = intH/1.8
	
	local btnRecordCamaraFrontal = display.newRoundedRect( intW/1.55, lastY, 190, 190, 10 )
	btnRecordCamaraFrontal:setFillColor( 1 )
	btnRecordCamaraFrontal.type = 1
	recordVisitScreen:insert(btnRecordCamaraFrontal)
	btnRecordCamaraFrontal:addEventListener( 'tap', takePhotography )
	
	local imgRecordCamaraFrontal = display.newImage( "img/btn/CAMARA.png" )
	imgRecordCamaraFrontal.x = intW/1.55
	imgRecordCamaraFrontal.y = lastY
	recordVisitScreen:insert(imgRecordCamaraFrontal)
	
	local bgRecordCamaraFrontal = display.newRoundedRect( intW/1.55, lastY + 140, 120, 35, 10 )
	bgRecordCamaraFrontal:setFillColor( 1 )
	bgRecordCamaraFrontal.type = 1
	recordVisitScreen:insert(bgRecordCamaraFrontal)
	
	local labelRecordCamaraFrontal= display.newText( {   
        x = intW/1.55, y = lastY + 140, width = 120,
        text = "Frente",  font = fontDefault, fontSize = 20, align = "center",
	})
	labelRecordCamaraFrontal:setFillColor( 64/255, 90/255, 139/255 )
	recordVisitScreen:insert(labelRecordCamaraFrontal)
	
	local btnRecordCamaraBack = display.newRoundedRect( intW/1.15, lastY, 190, 190, 10 )
	btnRecordCamaraBack:setFillColor( 1 )
	btnRecordCamaraBack.type = 2
	recordVisitScreen:insert(btnRecordCamaraBack)
	btnRecordCamaraBack:addEventListener( 'tap', takePhotography )
	
	local imgRecordCamaraBack = display.newImage( "img/btn/CAMARA.png" )
	imgRecordCamaraBack.x = intW/1.15
	imgRecordCamaraBack.y = lastY
	recordVisitScreen:insert(imgRecordCamaraBack)
	
	local bgRecordCamaraBack = display.newRoundedRect( intW/1.15, lastY + 140, 120, 35, 10 )
	bgRecordCamaraBack:setFillColor( 1 )
	bgRecordCamaraBack.type = 1
	recordVisitScreen:insert(bgRecordCamaraBack)
	
	local labelRecordCamaraFrontal= display.newText( {   
        x =  intW/1.15, y = lastY + 140, width = 120,
        text = "Vuelta",  font = fontDefault, fontSize = 20, align = "center",
	})
	labelRecordCamaraFrontal:setFillColor( 64/255, 90/255, 139/255 )
	recordVisitScreen:insert(labelRecordCamaraFrontal)
	
	lastY = intH/1.28
	
	--[[local imgArrowLeftCondo = display.newImage( "img/btn/btnBackward.png" )
	imgArrowLeftCondo.x = intW/1.9
	--imgArrowBack.height = 40
	--imgArrowBack.width = 40
	imgArrowLeftCondo.y = lastY
	recordVisitScreen:insert(imgArrowLeftCondo)
	
	local imgNumCondo= display.newImage( "img/btn/btnFilter.png" )
	imgNumCondo.x = intW/1.9 + 55
	--imgNumCondo.height = 40
	--imgNumCondo.width = 40
	imgNumCondo.y = lastY
	recordVisitScreen:insert(imgNumCondo)
	imgNumCondo:addEventListener( 'tap', showListCondominium )
	
	local labelRecordCamaraFrontal= display.newText( {   
        x = intW/1.9 + 245, y = lastY,
        text = "Selecionar condominio",  font = fontDefault, fontSize = 28, align = "center",
	})
	labelRecordCamaraFrontal:setFillColor( 0 )
	recordVisitScreen:insert(labelRecordCamaraFrontal)]]
	
	lastY = intH/1.2
	
	local btnRegisterVisit = display.newRoundedRect( intW/2, intH - 70, 280, 70, 10 )
	btnRegisterVisit:setFillColor( 205/255, 69/255, 69/255 )
	recordVisitScreen:insert(btnRegisterVisit)
	btnRegisterVisit:addEventListener( 'tap', sendRecordVisit )
	
	local labelRegisterVisit = display.newText( {   
        x = intW/2, y = intH - 70,
        text = "REGISTRAR VISITA",  font = fontDefault, fontSize = 24
	})
	labelRegisterVisit:setFillColor( 1 )
	recordVisitScreen:insert(labelRegisterVisit)
	
	
   
end

-- "scene:show()"
function scene:show( event )

	--[[if txtRecordVisitName then txtRecordVisitName.x = intW/4 end
	if txtRecordVisitReason then txtRecordVisitReason.x = intW/4 end
	if txtRecordNumCondo then txtRecordNumCondo.x = intW/4 end]]
	
	grpTextFieldRV.x = 0

	if txtRecordNumCondo then
		txtRecordNumCondo.text = Globals.numCondominium
	end
	
end

-- "scene:hide()"
function scene:hide( event )
	local phase = event.phase
	
	if phase == "will" then
		grpTextFieldRV.x = intW * 2
	end
   --phase == "will"
   --phase == "did"
   --local txtRecordVisitName
	--local txtRecordVisitReason
	--local txtRecordNumCondo
	
end

-- "scene:destroy()"
function scene:destroy( event )

	if grpTextFieldRV then
		grpTextFieldRV:removeSelf()
		grpTextFieldRV = nil
		grpTextFieldRV =display.newGroup()
	end
	
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene