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
		NewAlert("Enviando mensaje", 600, 200)
		
		local dateS2 = RestManager.getDate()
		
		idLastMSG = DBManager.saveRecordVisit(txtRecordVisitName.text, txtRecordVisitReason.text, labelNumCondominius.id, dateS2, timeStampPhoto)
		--idLastMSG = DBManager.saveRecordVisit("arturo jimenez", "visita a la empresa geek", labelNumCondominius.id, dateS2, "1111")
		
		RestManager.sendMSGRecordVisit()
		--RestManager.uploadImage()
		
		
		
	else
		--native.showAlert( "Booking", "Campos vacios", { "OK"})
		NewAlert("Campos vacios.", 600, 200)
		timeMarker = timer.performWithDelay( 2000, function()
			deleteNewAlert()
		end, 1 )
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
	
	local imgGuardTurn = display.newImage( settingsGuard.foto, system.TemporaryDirectory )
	--local imgGuardTurn = display.newImage( "img/btn/GUARDIA.png" )
	imgGuardTurn.x = intW/1.3
	imgGuardTurn.height = 100
	imgGuardTurn.width = 100
	imgGuardTurn.y = h + 90
	recordVisitScreen:insert(imgGuardTurn)
	
	local labelGuardTurn = display.newText( {   
        x = intW/1.3, y = h + 155,
        text = settingsGuard.nombre,  font = fontDefault, fontSize = 20
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
	txtRecordVisitName.placeholder = "VISITANTE"  
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
	txtRecordVisitReason.placeholder = "ASUNTO"
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
	
	labelNumCondominius = display.newText( {
		x = intW/5, y = lastY,
		width = 200,
        text = "SELECCIONAR CONDOMINIO",  font = fontDefault, fontSize = 20, align = "left"
	})
	labelNumCondominius:setFillColor( 64/255, 90/255, 139/255 )
	labelNumCondominius.id = 0
	recordVisitScreen:insert(labelNumCondominius)
	
	--[[txtRecordNumCondo = native.newTextField( intW/4 - 30, lastY, 340, 60 )
    txtRecordNumCondo.inputType = "number"
    txtRecordNumCondo.hasBackground = false
	txtRecordNumCondo.placeholder = "SELECCIONAR CONDOMINIO"
	txtRecordNumCondo.size = 20
	grpTextFieldRV:insert(txtRecordNumCondo)]]
	
	----- fotos -----
	
	lastY = intH/1.8
	
	local btnRecordCamaraFrontal = display.newRoundedRect( intW/1.55, lastY, 190, 190, 10 )
	btnRecordCamaraFrontal:setFillColor( 1 )
	btnRecordCamaraFrontal.type = 1
	recordVisitScreen:insert(btnRecordCamaraFrontal)
	btnRecordCamaraFrontal:addEventListener( 'tap', takePhotography )
	
	local imgRecordCamaraFrontal = display.newImage( "img/btn/CAMARA.png" )
	--local imgRecordCamaraFrontal = display.newImage( "/storage/emulated/0/Pictures/Picture19.jpg" )
	--local imgRecordCamaraFrontal = display.newImage( "/sdcard/Pictures/Picture19.jpg" )
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
	
	lastY = intH/1.2
	
	local btnRegisterVisit = display.newRoundedRect( intW/2, intH - 70, 300, 70, 10 )
	btnRegisterVisit:setFillColor( 205/255, 69/255, 69/255 )
	recordVisitScreen:insert(btnRegisterVisit)
	btnRegisterVisit:addEventListener( 'tap', sendRecordVisit )
	
	local labelRegisterVisit = display.newText( {   
        x = intW/2, y = intH - 70,
        text = "REGISTRAR VISITA",  font = fontDefault, fontSize = 28
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