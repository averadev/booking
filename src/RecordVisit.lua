-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Registrio de visitas
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

local scene = composer.newScene()

local settingsGuard = DBManager.getGuardActive()

--variables
local recordVisitScreen = display.newGroup()
local grpTextFieldRV = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont

----elementos
local txtRecordVisitName
local txtRecordVisitReason
local txtRecordNumCondo
local labelNumCondominius

local photoFrontal = nil
local photoBack = nil
local typePhoto = 0

local timeStampPhoto
local idLastMSG

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
	
--envia el mensaje al administrador
function sendMessageToadmin( event )
	native.showAlert( "Booking", "Mensaje enviado", { "OK"})
	composer.gotoScene("src.Home")
end

--llama a la scena de notificaciones
function goToNotificationMSG()
	composer.removeScene("src.Notification")
	composer.gotoScene("src.Notification", {
		time = 400,
		effect = "crossFade",
		params = { lastId = idLastMSG }
	})
end

--muestra la pantalla de condominio
function showListCondominium( event )
	composer.gotoScene("src.ListCondominium")
end

--regresa a la pantalla de home
function returnHomeRecordVisit( event )
	composer.gotoScene("src.Home")
end

--elimina las imagenes una vez subidas
function deleteImageRecordVisit(frente, vuelta)
	
	os.remove( system.pathForFile( "tempFotos/" .. frente, system.TemporaryDirectory  ) )
	os.remove( system.pathForFile( "tempFotos/" .. vuelta, system.TemporaryDirectory  ) )
	
end

--envia el mensaje
function sendRecordVisit( event )
	
	--print(RestManager.getDateCompound())

	--print(os.date( "%x" ) )
	--local TimeStamp = RestManager.getTimeStamp('2015-09-21T17:50:36.03-0400')
	--print(TimeStamp)
	--print(os.time())

	if txtRecordVisitName.text ~= '' and txtRecordVisitReason.text ~= '' and labelNumCondominius.id ~= 0 and photoFrontal ~= nil and photoBack ~= nil then
	--if txtRecordVisitName.text ~= '' and txtRecordVisitReason.text ~= '' and labelNumCondominius.id ~= 0 then
		
		--[[NewAlert("Visitante registrado.", 600, 200)
		timeMarker = timer.performWithDelay( 2000, function()
			deleteNewAlert()
		end, 1 )]]
		NewAlert("Booking","Enviando mensaje.", 0)
		
		local dateS2 = RestManager.getDate()
		
		idLastMSG = DBManager.saveRecordVisit(txtRecordVisitName.text, txtRecordVisitReason.text, labelNumCondominius.id, dateS2, timeStampPhoto)
		--idLastMSG = DBManager.saveRecordVisit("arturo jimenez", "visita a la empresa geek", labelNumCondominius.id, dateS2, "1111")
		
		RestManager.sendMSGRecordVisit()
		--RestManager.uploadImage()
		
		
		
	else
		--native.showAlert( "Booking", "Campos vacios", { "OK"})
		local msgError = "Por favor Introduce los siguientes datos faltantes: "
		if txtRecordVisitName.text == "" then
			msgError = msgError .. "\n*Visitante "
		end
		if txtRecordVisitReason.text == "" then
			msgError = msgError .. "\n*Motivo de la visita "
		end
		if labelNumCondominius.id == 0 then
			msgError = msgError .. "\n*Numero de condominio "
		end
		if photoFrontal == nil or photoBack == nil then
			msgError = msgError .. "\n*Fotos "
		end
		NewAlert("Datos Faltantes", msgError, 1)
	end
	--composer.gotoScene("src.Notification")
end

--camara
function takePhotography( event )

	typePhoto = event.target.type
	
	local namePhoto = timeStampPhoto .. typePhoto .. settingsGuard.id .. ".jpg"
	print ('nameFoto ' .. namePhoto)
	
	local group = display.newGroup()
	
	local function onComplete( event )
		print('adsadad')
		--local photo = event.target
		--[[photo.height = 150
		photo.width = 200
		photo.x = 100
		photo.y = intH/2.04]]
		
		--media.save( namePhoto, namePhoto, system.TemporaryDirectory )
		
		if typePhoto == 1 then
			
			if photoFrontal then
				photoFrontal:removeSelf()
				photoFrontal = nil
			end
			
			photoFrontal = display.newImage( "tempFotos/" .. namePhoto, system.TemporaryDirectory ) 
			photoFrontal.height = 190
			photoFrontal.width = 190
			photoFrontal.x = intW/1.55
			photoFrontal.y = intH/1.8
			recordVisitScreen:insert(photoFrontal)
		else
			
			if photoBack then
				photoBack:removeSelf()
				photoBack = nil
			end
			photoBack = display.newImage( "tempFotos/" .. namePhoto, system.TemporaryDirectory )
			photoBack.height = 190
			photoBack.width = 190
			photoBack.x = intW/1.15
			photoBack.y = intH/1.8
			recordVisitScreen:insert(photoBack)
		end
		
	end

	if media.hasSource( media.Camera ) then
		media.capturePhoto( { 
			listener=onComplete,
			destination = {
				baseDir = system.TemporaryDirectory,
				filename = "tempFotos/" .. namePhoto,
				type = "image"
			}
		} )
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
	
	local settingsGuard = DBManager.getGuardActive()
	
	local bgRecordVisit = display.newImage( "img/btn/fondo.png" )
	bgRecordVisit.anchorX = 0
	bgRecordVisit.anchorY = 0
	bgRecordVisit.width = intW
	bgRecordVisit.height = intH - h
	bgRecordVisit.y = h
	recordVisitScreen:insert(bgRecordVisit)
	
	local imgArrowBack = display.newImage( "img/btn/seleccionOpcion-regresarSuperior.png" )
	imgArrowBack.x = 30
	imgArrowBack.y = h + 40
	recordVisitScreen:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnHomeRecordVisit)
	
	local labelArrowBack = display.newText( {   
        x = 125, y = h + 40,
        text = "REGRESAR",  font = fontLatoBold, fontSize = 26
	})
	labelArrowBack:setFillColor( 1 )
	recordVisitScreen:insert(labelArrowBack)
	
	local labelWelcomeRecordVisit = display.newText( {   
        x = intW/2, y = h + 120, 
        text = "Registro de visita",  font = fontLatoRegular, fontSize = 36
	})
	labelWelcomeRecordVisit:setFillColor( 150/255, 254/255, 255/255 )
	recordVisitScreen:insert(labelWelcomeRecordVisit)
	
	--img guard
	
	local bgGuardTurn = display.newRoundedRect( intW - 200, h + 50, 300, 70, 10 )
	bgGuardTurn:setFillColor( 6/255, 58/255, 98/255 )
	bgGuardTurn.strokeWidth = 4
	bgGuardTurn:setStrokeColor( 54/255, 80/255, 131/255 )
	recordVisitScreen:insert(bgGuardTurn)
	
	local imgGuardTurn = display.newRoundedRect( intW - 312,  h + 50, 60, 60, 10 )
	imgGuardTurn:setFillColor( 1 )
	recordVisitScreen:insert(imgGuardTurn)
	
	local imgGuardTurn = display.newImage( settingsGuard.foto, system.TemporaryDirectory )
	--local imgGuardTurn = display.newImage( "img/btn/GUARDIA.png" )
	imgGuardTurn.x = intW - 312 
	imgGuardTurn.height = 40
	imgGuardTurn.width = 40
	imgGuardTurn.y = h + 50
	recordVisitScreen:insert(imgGuardTurn)
	
	local labelGuardTurn = display.newText( {   
        x = intW - 150, y = h + 50, width = 200,
        text = settingsGuard.nombre,  font = fontLatoLight, fontSize = 22,
	})
	labelGuardTurn:setFillColor( 1 )
	recordVisitScreen:insert(labelGuardTurn)
	
	local bgImgGuard = display.newRoundedRect( intW/2, h + 200, intW - 100, 450, 5 )
	bgImgGuard.anchorY = 0
	bgImgGuard:setFillColor( 6/255, 58/255, 98/255 )
	bgImgGuard.strokeWidth = 4
	bgImgGuard:setStrokeColor( 54/255, 80/255, 131/255 )
	recordVisitScreen:insert(bgImgGuard)
	
	local lineRecordVisit = display.newLine( intW/2, 280, intW/2, 580 )
	lineRecordVisit:setStrokeColor( 171/255, 30/255, 46/255 )
	lineRecordVisit.strokeWidth = 6
	recordVisitScreen:insert(lineRecordVisit)
	
	---- campo nombre del visitante
	
	lastY = 320
	
	local bgTextRecordVisitName = display.newRoundedRect( intW/4 + 35, lastY, 400, 60, 10 )
	bgTextRecordVisitName:setFillColor( 1 )
	recordVisitScreen:insert(bgTextRecordVisitName)
	
	local imgTextFieldName = display.newImage( "img/btn/icono-user.png" )
	imgTextFieldName.y = lastY
	imgTextFieldName.x =  intW/4 - 135
	recordVisitScreen:insert(imgTextFieldName)
	
	txtRecordVisitName = native.newTextField( intW/4 + 65, lastY, 340, 60 )
    txtRecordVisitName.inputType = "email"
    txtRecordVisitName.hasBackground = false
	txtRecordVisitName.placeholder = "VISITANTE"  
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtRecordVisitName.size = 20
	grpTextFieldRV:insert(txtRecordVisitName)
	
	---- campo motivo del visitante
	
	lastY = lastY + 110
	
	local bgTextRecordVisitReason = display.newRoundedRect( intW/4 + 35, lastY, 400, 120, 10 )
	bgTextRecordVisitReason:setFillColor( 1 )
	recordVisitScreen:insert(bgTextRecordVisitReason)
	
	local imgTextFieldReason = display.newImage( "img/btn/registro-asunto.png" )
	imgTextFieldReason.y = lastY
	imgTextFieldReason.x =  intW/4 - 135
	recordVisitScreen:insert(imgTextFieldReason)
	
	txtRecordVisitReason = native.newTextBox( intW/4 + 65, lastY, 340, 120 )
    txtRecordVisitReason.hasBackground = false
	txtRecordVisitReason.isEditable = true
	txtRecordVisitReason.placeholder = "ASUNTO"
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtRecordVisitReason.size = 24
	grpTextFieldRV:insert(txtRecordVisitReason)
	
	----- campo num. condominio
	
	lastY = lastY + 110
	
	local bgTextRecordNumCondo = display.newRoundedRect( intW/4 + 35, lastY, 400, 60, 10 )
	bgTextRecordNumCondo:setFillColor( 1 )
	recordVisitScreen:insert(bgTextRecordNumCondo)
	
	local imgComboNumCondo = display.newImage( "img/btn/registro-seleccionarCondo.png" )
	imgComboNumCondo.y = lastY
	imgComboNumCondo.x =  intW/4 - 135
	recordVisitScreen:insert(imgComboNumCondo)
	
	local imgNumCondo = display.newImage( "img/btn/optionCondo.png" )
	imgNumCondo.x = intW/4 + 190
	imgNumCondo.y = lastY
	imgNumCondo.height = 35
	imgNumCondo.width = 40
	recordVisitScreen:insert(imgNumCondo)
	imgNumCondo:addEventListener( 'tap', showListCondominium)
	
	labelNumCondominius = display.newText( {
		x = intW/4, y = lastY,
		width = 200,
        text = "SELECCIONAR CONDOMINIO",  font = fontDefault, fontSize = 20, align = "left"
	})
	labelNumCondominius:setFillColor( 64/255, 90/255, 139/255 )
	labelNumCondominius.id = 0
	recordVisitScreen:insert(labelNumCondominius)
	
	----- fotos -----
	
	lastY = 385
	
	local btnRecordCamaraFrontal = display.newRoundedRect( intW/1.61, lastY, 190, 190, 10 )
	btnRecordCamaraFrontal:setFillColor( 1 )
	btnRecordCamaraFrontal.type = 1
	recordVisitScreen:insert(btnRecordCamaraFrontal)
	btnRecordCamaraFrontal:addEventListener( 'tap', takePhotography )
	
	local imgRecordCamaraFrontal = display.newImage( "img/btn/CAMARA.png" )
	--local imgRecordCamaraFrontal = display.newImage( "/storage/emulated/0/Pictures/Picture19.jpg" )
	--local imgRecordCamaraFrontal = display.newImage( "/sdcard/Pictures/Picture19.jpg" )
	imgRecordCamaraFrontal.x = intW/1.61
	imgRecordCamaraFrontal.y = lastY
	recordVisitScreen:insert(imgRecordCamaraFrontal)
	
	local bgRecordCamaraFrontal = display.newRect( intW/1.61, lastY + 140, 190, 40 )
	bgRecordCamaraFrontal:setFillColor( 1 )
	bgRecordCamaraFrontal.type = 1
	recordVisitScreen:insert(bgRecordCamaraFrontal)
	
	local labelRecordCamaraFrontal= display.newText( {   
        x = intW/1.61, y = lastY + 140, width = 120,
        text = "Frente",  font = fontDefault, fontSize = 20, align = "center",
	})
	labelRecordCamaraFrontal:setFillColor( 0 )
	recordVisitScreen:insert(labelRecordCamaraFrontal)
	
	local btnRecordCamaraBack = display.newRoundedRect( intW/1.21, lastY, 190, 190, 10 )
	btnRecordCamaraBack:setFillColor( 1 )
	btnRecordCamaraBack.type = 2
	recordVisitScreen:insert(btnRecordCamaraBack)
	btnRecordCamaraBack:addEventListener( 'tap', takePhotography )
	
	local imgRecordCamaraBack = display.newImage( "img/btn/CAMARA.png" )
	imgRecordCamaraBack.x = intW/1.21
	imgRecordCamaraBack.y = lastY
	recordVisitScreen:insert(imgRecordCamaraBack)
	
	local bgRecordCamaraBack = display.newRect( intW/1.21, lastY + 140, 190, 40 )
	bgRecordCamaraBack:setFillColor( 1 )
	bgRecordCamaraBack.type = 1
	recordVisitScreen:insert(bgRecordCamaraBack)
	
	local labelRecordCamaraFrontal= display.newText( {   
        x =  intW/1.21, y = lastY + 140, width = 120,
        text = "Vuelta",  font = fontDefault, fontSize = 20, align = "center",
	})
	labelRecordCamaraFrontal:setFillColor( 0 )
	recordVisitScreen:insert(labelRecordCamaraFrontal)
	
	lastY = lastY + 250
	
	local paint = {
		type = "gradient",
		color1 = { 49/255, 187/255, 40/255 },
		color2 = { 45/255, 161/255, 45/255, 0.9 },
		direction = "down"
	}
	
	local btnRegisterVisit = display.newRoundedRect( intW/2, lastY, 200, 70, 10 )
	btnRegisterVisit:setFillColor( 205/255, 69/255, 69/255 )
	btnRegisterVisit.fill = paint
	recordVisitScreen:insert(btnRegisterVisit)
	btnRegisterVisit:addEventListener( 'tap', sendRecordVisit )
	
	local labelRegisterVisit = display.newText( {   
        x = intW/2, y = lastY,
        text = "ENVIAR",  font = fontDefault, fontSize = 28
	})
	labelRegisterVisit:setFillColor( 1 )
	recordVisitScreen:insert(labelRegisterVisit)
   
end

-- "scene:show()"
function scene:show( event )

	--[[if txtRecordVisitName then txtRecordVisitName.x = intW/4 end
	if txtRecordVisitReason then txtRecordVisitReason.x = intW/4 end
	if txtRecordNumCondo then txtRecordNumCondo.x = intW/4 end]]
	
	timeStampPhoto = os.time()
	
	grpTextFieldRV.x = 0

	if labelNumCondominius then
		if Globals.numCondominium == 0 then
			labelNumCondominius.text = "SELECCIONAR CONDOMINIO"
			labelNumCondominius.id = Globals.idCondominium
		else
			labelNumCondominius.text = Globals.numCondominium
			labelNumCondominius.id = Globals.idCondominium
		end
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