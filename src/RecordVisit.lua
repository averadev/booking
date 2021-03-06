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
local recordVisitField = display.newGroup()

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

local labelWelcomeRecordVisit

local photoFrontal = nil
local photoBack = nil
local typePhoto = 0
local residencial

local timeStampPhoto
local idLastMSG

local imgUnCheckesRecordVisit
local imgCheckesRecordVisit

local provider = 0

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
	native.showAlert( "Plantec Security", "Mensaje enviado", { "OK"})
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

--muestra la pantalla de condominio
function showListSubject( event )
	composer.gotoScene("src.ListSubject")
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
	local dateS2 = RestManager.getDate()
	
	local requireFoto = 0
	if residencial == 0 then
		requireFoto = 1
	else
		requireFoto = residencial[1].requireFoto
	end
	
	if requireFoto == 0 then
		photoFrontal = ""
		photoBack = ""
		timeStampPhoto = ""
	end

	if txtRecordVisitName.text ~= '' and txtRecordVisitReason.text ~= '' and labelNumCondominius.id ~= 0 and photoFrontal ~= nil and photoBack ~= nil then
	--if txtRecordVisitName.text ~= '' and txtRecordVisitReason.text ~= '' and labelNumCondominius.id ~= 0 then
		
		NewAlert("Plantec Security","Enviando mensaje.", 0)
		if requireFoto == 1 or requireFoto == '1' then
		
			for i = 1, 2, 1 do
			
				local namePhoto = "tempFotos/" .. timeStampPhoto .. i .. settingsGuard.id .. ".jpg"
				
				--local namePhoto =  "tempFotos/1111" .. i .. settingsGuard.id .. ".jpg"
		
				local grupoA =  display.newGroup()
				local photo1 = display.newImage( namePhoto, system.TemporaryDirectory )
				--photo1.height = photo1.contentHeight/2
				--photo1.width = photo1.contentWidth/2
				photo1.width = (400 * photo1.contentWidth) / photo1.contentHeight
				photo1.height = 400
				photo1.x = intW/2
				photo1.y = intH/2
				grupoA:insert(photo1)
		
				display.save( grupoA, { filename=namePhoto, baseDir=system.TemporaryDirectory, isFullResolution=false, backgroundColor={0, 0, 0, 0} } )
		
				grupoA:removeSelf()
				grupoA = nil
		
			end
		
		end
		
		local dateS2 = RestManager.getDate()
		
		idLastMSG = DBManager.saveRecordVisit(txtRecordVisitName.text, txtRecordVisitReason.text, labelNumCondominius.id, dateS2, timeStampPhoto, provider)
		--idLastMSG = DBManager.saveRecordVisit("arturo jimenez", "visita a la empresa geek", labelNumCondominius.id, dateS2, timeStampPhoto, provider)
		
		RestManager.sendMSGRecordVisit()
		--RestManager.uploadImage()
		
	else
		--native.showAlert( "Plantec Security", "Campos vacios", { "OK"})
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

	--[[local grupoA =  display.newGroup()
		photoFrontal = display.newImage( "playa.jpg", system.TemporaryDirectory )
		photoFrontal.height = 330
		photoFrontal.width = 466
		photoFrontal.x = intW/1.61
		photoFrontal.y = 385
		grupoA:insert(photoFrontal)
		
	--local baseDir = system.DocumentsDirectory
	display.save( grupoA, { filename="hola.jpg", baseDir=system.TemporaryDirectory, isFullResolution=false, backgroundColor={0, 0, 0, 0} } )]]

	typePhoto = event.target.type
	
	
	
	local namePhoto = timeStampPhoto .. typePhoto .. settingsGuard.id .. ".jpg"
	
	local group = display.newGroup()
	
	local function onComplete( event )
		--local photo = event.target
		--[[photo.height = 150
		photo.width = 200
		photo.x = 100
		photo.y = intH/2.04]]
		
		--media.save( namePhoto, namePhoto, system.TemporaryDirectory )
		local leftMid = (intW - 200) / 4
        local rightMid = (leftMid * 3) + 30
		if typePhoto == 1 then
			
			if photoFrontal then
				photoFrontal:removeSelf()
				photoFrontal = nil
			end
			
			photoFrontal = display.newImage( "tempFotos/" .. namePhoto, system.TemporaryDirectory ) 
			photoFrontal.height = 127
			photoFrontal.width = 170
			photoFrontal.x = rightMid - 95
			photoFrontal.y = 370
			--photoFrontal.width = (255 * photoFrontal.contentWidth) / photoFrontal.contentHeight
			--photoFrontal.height = 255
			recordVisitField:insert(photoFrontal)
			
		else
			
			if photoBack then
				photoBack:removeSelf()
				photoBack = nil
			end
			photoBack = display.newImage( "tempFotos/" .. namePhoto, system.TemporaryDirectory )
			photoBack.height = 127
			photoBack.width = 170
			photoBack.x = rightMid + 95
			photoBack.y = 370
			recordVisitField:insert(photoBack)
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

function onTxtFocusRecord( event )

	if ( event.phase == "began" ) then
		bgTextField.y = h + 30
		recordVisitField.y = h - 165
		grpTextFieldRV.y = h - 165
    elseif ( event.phase == "ended" ) then
		native.setKeyboardFocus( nil )
		bgTextField.y = h + 150
		recordVisitField.y = 0
		grpTextFieldRV.y = 0
    elseif ( event.phase == "submitted" ) then
		native.setKeyboardFocus( nil )
		bgTextField.y = h + 150
		recordVisitField.y = 0
		grpTextFieldRV.y = 0
    elseif event.phase == "editing" then
		
    end

end

--function para el chechBock
function userChechProvider( event )

	if event.target.typeC == 0 then
		provider = 1
		imgUnCheckesRecordVisit.alpha = 0
		imgCheckesRecordVisit.alpha = 1
	elseif event.target.typeC == 1 then
		provider = 0
		imgUnCheckesRecordVisit.alpha = 1
		imgCheckesRecordVisit.alpha = 0
	end
	
	return true

end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local screen = self.view
    local midScreen = (intW/2)-75
	
	screen:insert(recordVisitScreen)
	screen:insert(recordVisitField)
	
	local settingsGuard = DBManager.getGuardActive()
	
	local bgLogin = display.newRect( intW/2, h, intW, intH )
    bgLogin.fill = { type="image", filename="img/btn/fillPattern.jpg" }
	bgLogin.anchorY = 0
	recordVisitScreen:insert(bgLogin)
	
	local imgArrowBack = display.newImage( "img/btn/seleccionOpcion-regresarSuperior.png" )
	imgArrowBack.x = 30
	imgArrowBack.y = h + 40
	recordVisitScreen:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnHomeRecordVisit)
	
	local labelArrowBack = display.newText( {   
        x = 125, y = h + 40,
        text = "REGRESAR",  font = fontLatoBold, fontSize = 26
	})
	labelArrowBack:setFillColor( .2 )
	recordVisitScreen:insert(labelArrowBack)
	labelArrowBack:addEventListener( 'tap', returnHomeRecordVisit)
	
	labelWelcomeRecordVisit = display.newText( {   
        x = midScreen, y = h + 110,
        text = "Registro de visita",  font = fontLatoRegular, fontSize = 36
	})
	labelWelcomeRecordVisit:setFillColor( .2 )
	recordVisitScreen:insert(labelWelcomeRecordVisit)
	
	--img guard
	
	local bgGuardTurn = display.newRoundedRect( intW - 290, h + 50, 250, 70, 10 )
	bgGuardTurn:setFillColor( 6/255, 58/255, 98/255 )
	bgGuardTurn.strokeWidth = 4
	bgGuardTurn:setStrokeColor( 54/255, 80/255, 131/255 )
	recordVisitScreen:insert(bgGuardTurn)
	
	local imgGuardTurn = display.newRoundedRect( intW - 372,  h + 50, 60, 60, 10 )
	imgGuardTurn:setFillColor( 1 )
	recordVisitScreen:insert(imgGuardTurn)
	
	local imgGuardTurn = display.newImage( settingsGuard.foto, system.TemporaryDirectory )
	--local imgGuardTurn = display.newImage( "img/btn/GUARDIA.png" )
	imgGuardTurn.x = intW - 372 
	imgGuardTurn.height = 40
	imgGuardTurn.width = 40
	imgGuardTurn.y = h + 50
	recordVisitScreen:insert(imgGuardTurn)
	
	local labelGuardTurn = display.newText( {   
        x = intW - 230, y = h + 50, width = 200,
        text = settingsGuard.nombre,  font = fontLatoLight, fontSize = 22,
	})
	labelGuardTurn:setFillColor( 1 )
	recordVisitScreen:insert(labelGuardTurn)
	
	bgTextField = display.newRoundedRect( midScreen, h + 150, intW - 200, 460, 5 )
	bgTextField.anchorY = 0
	bgTextField:setFillColor( 6/255, 58/255, 98/255 )
	bgTextField.strokeWidth = 4
	bgTextField:setStrokeColor( 54/255, 80/255, 131/255 )
	recordVisitScreen:insert(bgTextField)
	
	lastY = 230
	
	---chechBock
	local leftMid = (intW - 200) / 4
	imgUnCheckesRecordVisit = display.newImage( "img/btn/uncheckes.png" )
	imgUnCheckesRecordVisit.y = lastY
	imgUnCheckesRecordVisit.x =  leftMid - 135
	imgUnCheckesRecordVisit.typeC = 0
	recordVisitField:insert(imgUnCheckesRecordVisit)
	imgUnCheckesRecordVisit:addEventListener( 'tap', userChechProvider)
	
	imgCheckesRecordVisit = display.newImage( "img/btn/checked.png" )
	imgCheckesRecordVisit.y = lastY
	imgCheckesRecordVisit.x =  leftMid - 135
	imgCheckesRecordVisit.alpha = 0
	imgCheckesRecordVisit.typeC = 1
	recordVisitField:insert(imgCheckesRecordVisit)
	imgCheckesRecordVisit:addEventListener( 'tap', userChechProvider)
	
	labelProviderRecordVisit = display.newText( {
		x = leftMid, y = lastY,
		width = 200,
        text = "ES PROVEEDOR",  font = fontDefault, fontSize = 20, align = "left"
	})
	labelProviderRecordVisit:setFillColor( 1 )
	recordVisitField:insert(labelProviderRecordVisit)
	
	---- campo nombre del visitante
	
	lastY = 310
	
	local bgTextRecordVisitName = display.newRoundedRect( leftMid + 35, lastY, 400, 60, 10 )
	bgTextRecordVisitName:setFillColor( 1 )
	recordVisitField:insert(bgTextRecordVisitName)
	
	local imgTextFieldName = display.newImage( "img/btn/icono-user.png" )
	imgTextFieldName.y = lastY
	imgTextFieldName.x =  leftMid - 135
	recordVisitField:insert(imgTextFieldName)
	
	txtRecordVisitName = native.newTextField( leftMid + 65, lastY, 340, 60 )
    txtRecordVisitName.inputType = "email"
    txtRecordVisitName.hasBackground = false
	txtRecordVisitName.placeholder = "VISITANTE"  
	txtRecordVisitName:addEventListener( "userInput", onTxtFocusRecord )
	--txtSignEmail:setReturnKey(  "next"  )
	txtRecordVisitName.size = 20
	grpTextFieldRV:insert(txtRecordVisitName)
	
	---- campo motivo del visitante
	
	lastY = lastY + 80
	txtRecordVisitReason = display.newRoundedRect( leftMid + 35, lastY, 400, 60, 10 )
    txtRecordVisitReason.text = ''
	txtRecordVisitReason:setFillColor( 1 )
	recordVisitField:insert(txtRecordVisitReason)
	txtRecordVisitReason:addEventListener( 'tap', showListSubject)
	
	local imgTextFieldReason = display.newImage( "img/btn/registro-asunto.png" )
	imgTextFieldReason.y = lastY
	imgTextFieldReason.x =  leftMid - 135
	recordVisitField:insert(imgTextFieldReason)
    
    local imgAsunto = display.newImage( "img/btn/optionCondo.png" )
	imgAsunto.x = leftMid + 190
	imgAsunto.y = lastY
	imgAsunto.height = 35
	imgAsunto.width = 40
	recordVisitField:insert(imgAsunto)
	
	labelAsunto = display.newText( {
		x = leftMid, y = lastY,
		width = 200,
        text = "MOTIVO VISITA",  font = fontDefault, fontSize = 20, align = "left"
	})
	labelAsunto:setFillColor( 64/255, 90/255, 139/255 )
	labelAsunto.id = 0
	recordVisitField:insert(labelAsunto)
	
	----- campo num. condominio
	
	lastY = lastY + 80
	
	local bgTextRecordNumCondo = display.newRoundedRect( leftMid + 35, lastY, 400, 60, 10 )
	bgTextRecordNumCondo:setFillColor( 1 )
	recordVisitField:insert(bgTextRecordNumCondo)
	bgTextRecordNumCondo:addEventListener( 'tap', showListCondominium)
	
	local imgComboNumCondo = display.newImage( "img/btn/registro-seleccionarCondo.png" )
	imgComboNumCondo.y = lastY
	imgComboNumCondo.x =  leftMid - 135
	recordVisitField:insert(imgComboNumCondo)
	
	local imgNumCondo = display.newImage( "img/btn/optionCondo.png" )
	imgNumCondo.x = leftMid + 190
	imgNumCondo.y = lastY
	imgNumCondo.height = 35
	imgNumCondo.width = 40
	recordVisitField:insert(imgNumCondo)
	
	labelNumCondominius = display.newText( {
		x = leftMid, y = lastY,
		width = 200,
        text = "SELECCIONAR CONDOMINIO",  font = fontDefault, fontSize = 20, align = "left"
	})
	labelNumCondominius:setFillColor( 64/255, 90/255, 139/255 )
	labelNumCondominius.id = 0
	recordVisitField:insert(labelNumCondominius)
	
	----- fotos -----
	
	residencial = DBManager.getResidential()
	local requireFoto = 0
	if residencial == 0 then
		requireFoto = 1
	else
		requireFoto = residencial[1].requireFoto
	end
	
	if requireFoto == 1 then
	
        lastY = 370
        local rightMid = (leftMid * 3) + 30
        
        local lineRecordVisit = display.newLine( midScreen + 20, 270, midScreen + 20, 530 )
        lineRecordVisit:setStrokeColor( 171/255, 30/255, 46/255, .7 )
        lineRecordVisit.strokeWidth = 3
        recordVisitField:insert(lineRecordVisit)

        local btnRecordCamaraFrontal = display.newRoundedRect( rightMid - 95, lastY, 170, 170, 10 )
        btnRecordCamaraFrontal:setFillColor( 1 )
        btnRecordCamaraFrontal.type = 1
        recordVisitField:insert(btnRecordCamaraFrontal)
        btnRecordCamaraFrontal:addEventListener( 'tap', takePhotography )

        local imgRecordCamaraFrontal = display.newImage( "img/btn/CAMARA.png" )
        imgRecordCamaraFrontal.x = rightMid - 95
        imgRecordCamaraFrontal.y = lastY
        recordVisitField:insert(imgRecordCamaraFrontal)

        local bgRecordCamaraFrontal = display.newRect( rightMid - 95, lastY + 130, 170, 40 )
        bgRecordCamaraFrontal:setFillColor( 1 )
        bgRecordCamaraFrontal.type = 1
        recordVisitField:insert(bgRecordCamaraFrontal)

        local labelRecordCamaraFrontal= display.newText( {   
            x = rightMid - 95, y = lastY + 130, width = 120,
            text = "Frente",  font = fontLatoRegular, fontSize = 20, align = "center",
        })
        labelRecordCamaraFrontal:setFillColor( 0 )
        recordVisitField:insert(labelRecordCamaraFrontal)

        local btnRecordCamaraBack = display.newRoundedRect( rightMid + 95, lastY, 170, 170, 10 )
        btnRecordCamaraBack:setFillColor( 1 )
        btnRecordCamaraBack.type = 2
        recordVisitField:insert(btnRecordCamaraBack)
        btnRecordCamaraBack:addEventListener( 'tap', takePhotography )

        local imgRecordCamaraBack = display.newImage( "img/btn/CAMARA.png" )
        imgRecordCamaraBack.x = rightMid + 95
        imgRecordCamaraBack.y = lastY
        recordVisitField:insert(imgRecordCamaraBack)

        local bgRecordCamaraBack = display.newRect( rightMid + 95, lastY + 130, 170, 40 )
        bgRecordCamaraBack:setFillColor( 1 )
        bgRecordCamaraBack.type = 2
        recordVisitField:insert(bgRecordCamaraBack)

        local labelRecordCamaraVuelta= display.newText( {   
            x =  rightMid + 95, y = lastY + 130, width = 120,
            text = "Vuelta",  font = fontLatoRegular, fontSize = 20, align = "center",
        })
        labelRecordCamaraVuelta:setFillColor( 0 )
        recordVisitField:insert(labelRecordCamaraVuelta)
	
	end
	
	lastY = intH - 170
	
	local paint = {
		type = "gradient",
		color1 = { 49/255, 187/255, 40/255 },
		color2 = { 45/255, 161/255, 45/255, 0.9 },
		direction = "down"
	}
	
	local btnRegisterVisit = display.newRoundedRect( midScreen + 20, lastY, 200, 70, 10 )
	btnRegisterVisit:setFillColor( 205/255, 69/255, 69/255 )
	btnRegisterVisit.fill = paint
	recordVisitField:insert(btnRegisterVisit)
	btnRegisterVisit:addEventListener( 'tap', sendRecordVisit )
	
	local labelRegisterVisit = display.newText( {   
        x = midScreen + 20, y = lastY,
        text = "ENVIAR",  font = fontLatoRegular, fontSize = 28
	})
	labelRegisterVisit:setFillColor( 1 )
	recordVisitField:insert(labelRegisterVisit)
   
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

    if labelAsunto then
        print("Globals.numSubjectminium: "..Globals.numSubjectminium)
        print("Globals.idSubjectminium: "..Globals.idSubjectminium)
        if not (Globals.numSubjectminium == 0) then
            labelAsunto.text = Globals.numSubjectminium
            txtRecordVisitReason.text = Globals.numSubjectminium
        end
	end
end

-- "scene:hide()"
function scene:hide( event )

	native.setKeyboardFocus( nil )

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