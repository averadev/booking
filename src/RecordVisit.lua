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
	bgRecordVisit:setFillColor( 214/255, 226/255, 225/255 )
	recordVisitScreen:insert(bgRecordVisit)
	
	local imgLogo = display.newRect( intW/4, h + 100, 150, 150 )
	imgLogo:setFillColor( 0 )
	recordVisitScreen:insert(imgLogo)
	
	local labelRecord = display.newText( {   
        x = intW/2 + 100, y = h + 100,
        text = "Guardia en turno:",  font = fontDefault, fontSize = 34
	})
	labelRecord:setFillColor( 0 )
	recordVisitScreen:insert(labelRecord)
	
	local imgArrowBack = display.newImage( "img/btn/arrowBack.png" )
	imgArrowBack.x = intW - 50
	imgArrowBack.height = 60
	imgArrowBack.width = 90
	imgArrowBack.y = h + imgArrowBack.contentHeight/2
	recordVisitScreen:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnHomeRecordVisit)
	
	---- campo nombre del visitante
	
	lastY = intH/2.3
	
	local bgTextRecordVisitName = display.newRect( intW/4, lastY, 400, 60 )
	bgTextRecordVisitName:setFillColor( 1 )
	recordVisitScreen:insert(bgTextRecordVisitName)
	
	txtRecordVisitName = native.newTextField( intW/4, lastY, 400, 60 )
    txtRecordVisitName.inputType = "email"
    txtRecordVisitName.hasBackground = false
	txtRecordVisitName.placeholder = "Nombre del visitante"
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtRecordVisitName.size = 20
	grpTextFieldRV:insert(txtRecordVisitName)
	
	---- campo motivo del visitante
	
	lastY = intH/1.65
	
	local bgTextRecordVisitReason = display.newRect( intW/4, lastY, 400, 120 )
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
	
	lastY = intH/1.28
	
	local bgTextRecordNumCondo = display.newRect( intW/4, lastY, 400, 60 )
	bgTextRecordNumCondo:setFillColor( 1 )
	recordVisitScreen:insert(bgTextRecordNumCondo)
	
	txtRecordNumCondo = native.newTextField( intW/4, lastY, 400, 60 )
    txtRecordNumCondo.inputType = "email"
    txtRecordNumCondo.hasBackground = false
	txtRecordNumCondo.placeholder = "Nombre del visitante"
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtRecordNumCondo.size = 20
	grpTextFieldRV:insert(txtRecordNumCondo)
	
	----- fotos -----
	
	lastY = intH/2.04
	
	local btnRecordCamaraFrontal = display.newRect( intW/1.65, lastY, 200, 150 )
	btnRecordCamaraFrontal:setFillColor( 1 )
	btnRecordCamaraFrontal.type = 1
	recordVisitScreen:insert(btnRecordCamaraFrontal)
	btnRecordCamaraFrontal:addEventListener( 'tap', takePhotography )
	
	local labelRecordCamaraFrontal= display.newText( {   
        x = intW/1.7, y = lastY - 105, width = 200,
        text = "Frente",  font = fontDefault, fontSize = 28, align = "right",
	})
	labelRecordCamaraFrontal:setFillColor( 0 )
	recordVisitScreen:insert(labelRecordCamaraFrontal)
	
	local imgRecordCamaraFrontal = display.newImage( "img/btn/iconCamera.png" )
	imgRecordCamaraFrontal.x = intW/1.65
	imgRecordCamaraFrontal.y = lastY
	recordVisitScreen:insert(imgRecordCamaraFrontal)
	
	local btnRecordCamaraBack = display.newRect( intW/1.18, lastY, 200, 150 )
	btnRecordCamaraBack:setFillColor( 1 )
	btnRecordCamaraBack.type = 2
	recordVisitScreen:insert(btnRecordCamaraBack)
	btnRecordCamaraBack:addEventListener( 'tap', takePhotography )
	
	local labelRecordCamaraFrontal= display.newText( {   
        x =  intW/1.21, y = lastY - 105, width = 200,
        text = "Vuelta",  font = fontDefault, fontSize = 28, align = "right",
	})
	labelRecordCamaraFrontal:setFillColor( 0 )
	recordVisitScreen:insert(labelRecordCamaraFrontal)
	
	local imgRecordCamaraBack = display.newImage( "img/btn/iconCamera.png" )
	imgRecordCamaraBack.x = intW/1.18
	imgRecordCamaraBack.y = lastY
	recordVisitScreen:insert(imgRecordCamaraBack)
	
	lastY = intH/1.28
	
	local imgArrowLeftCondo = display.newImage( "img/btn/btnBackward.png" )
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
	recordVisitScreen:insert(labelRecordCamaraFrontal)
	
	lastY = intH/1.2
	
	local btnRegisterVisit = display.newRect( intW/2, intH - 60, 400, 65 )
	btnRegisterVisit:setFillColor( .2 )
	recordVisitScreen:insert(btnRegisterVisit)
	btnRegisterVisit:addEventListener( 'tap', sendRecordVisit )
	
	local labelRegisterVisit = display.newText( {   
        x = intW/2, y = intH - 60,
        text = "Registrar visita",  font = fontDefault, fontSize = 28
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