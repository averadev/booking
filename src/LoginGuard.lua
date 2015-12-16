-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login Guardia
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes
require('src.BuildItem')
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
local scene = composer.newScene()

local settings = DBManager.getSettings()
local settingsGuard = DBManager.getGuards()

-------variables
--grupos
local loginGuardScreen = display.newGroup()
local groupChangeCondo = display.newGroup()
local groupInfoGuard = display.newGroup()
local groupPassScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont

----elementos
local txtSignPasswordGuard
local txtSignPasswordChangeCondo

local btnSignLoginGuard

local currentGuard = nil

local GuardCondo = {}

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

function gotoHome(idGuard, name, photo)
	composer.removeScene("src.Home")
	composer.gotoScene("src.Home")
end

--crea los guardias
function buildItemsGuard()
	
	local lastY = h + 150
	
	local lastX = 150
	
	for i = 1, #settingsGuard, 1 do
	
		GuardCondo[i] = display.newContainer( 120, 120 )
		--GuardCondo[i].x = intW/5.7 * i - 50
		GuardCondo[i].x = lastX * i
		GuardCondo[i].y = lastY
		GuardCondo[i].id = settingsGuard[i].id
		GuardCondo[i].num = i
		groupInfoGuard:insert(GuardCondo[i])
		GuardCondo[i]:addEventListener( 'tap', SelecGuard )
		
		bgImgGuard = display.newRoundedRect( 0, 0, 120, 120, 10 )
		bgImgGuard:setFillColor( 1 )
		GuardCondo[i]:insert(bgImgGuard)
		
		local imgGuard = display.newImage( settingsGuard[i].foto, system.TemporaryDirectory )
		imgGuard.x = 0
		imgGuard.y = 0
		GuardCondo[i]:insert(imgGuard)
	
	end
	
end

function doSignInGuard( event )
	if txtSignPasswordGuard.text ~= '' and currentGuard ~= nil then
		--local result = DBManager.validateGuard('123',GuardCondo[currentGuard].id)
		local result = DBManager.validateGuard(txtSignPasswordGuard.text,GuardCondo[currentGuard].id)
		if result == 1 then
			NewAlert("Plantec Security","Contraseña incorrecta.", 1)
		else
			composer.removeScene("src.Home")
			composer.gotoScene("src.Home")
		end
	else
		local msgError = "Por favor Introduce los siguientes datos faltantes: "
		if currentGuard == nil then
			msgError = msgError .. "\nSelecionar un guardia "
		end
		if txtSignPasswordGuard.text == "" then
			msgError = msgError .. "\nContrasela del guardia "
		end
		NewAlert("Datos Faltantes", msgError, 1)
	end
	
end


--regresa a la pantalla de login
function signOut()

	if txtSignPasswordGuard then txtSignPasswordGuard:removeSelf() txtSignPasswordGuard = nil end
	if txtSignPasswordChangeCondo then txtSignPasswordChangeCondo:removeSelf() txtSignPasswordChangeCondo = nil end
	
	composer.removeScene("src.Login")
	composer.gotoScene("src.Login")

end

--regresa a la pantalla de login
function changeCondo( event )
	
	if txtSignPasswordChangeCondo.text ~= "" then
		RestManager.signOut(txtSignPasswordChangeCondo.text)
		--RestManager.signOut("123")
	else
		NewAlert("Plantec Security","Campo Vacio.", 1)
	end
	
end

--muestra el formulario para cambiar de condominio
function showChangeCondo( event )

	loginGuardScreen:insert(groupChangeCondo)

	--groupChangeCondo
	txtSignPasswordGuard.x = - intW
	
	local bgChangeCombo = display.newRect( 0, h, intW, intH )
	bgChangeCombo.anchorX = 0
	bgChangeCombo.anchorY = 0
	bgChangeCombo:setFillColor( 0 )
	bgChangeCombo.alpha = .5
	groupChangeCondo:insert(bgChangeCombo)
	bgChangeCombo:addEventListener( 'tap', hideChangeCombo )
	
	local bodyChangeCombo = display.newRect( intW/2, intH/2, intW/1.2, intH/1.4 )
	bodyChangeCombo:setFillColor( 6/255, 58/255, 98/255 )
	bodyChangeCombo.strokeWidth = 4
	bodyChangeCombo:setStrokeColor( 54/255, 80/255, 131/255 )
	groupChangeCondo:insert(bodyChangeCombo)
	bodyChangeCombo:addEventListener( 'tap', noAction )
	
	local labelLegend = "PARA CAMBIAR EL CONDOMINIO ASIGNADO ES NECESARIO INTRODUCIR LA CONTRASEÑA DEL ADMINISTRADOR"
	
	local labellegendChangeCondo = display.newText( {   
        x = intW/2, y = intH/4 + h,
		width = bodyChangeCombo.contentWidth - 100,
        text = labelLegend,  font = fontDefault, fontSize = 36, align = "center"
	})
	labellegendChangeCondo:setFillColor( 1 )
	groupChangeCondo:insert(labellegendChangeCondo)
	
	lastY = intH/1.8
	
	local bgTextPasswordChangeCondo = display.newRoundedRect( intW/2, lastY, 300, 60, 10 )
	bgTextPasswordChangeCondo:setFillColor( 1 )
	groupChangeCondo:insert(bgTextPasswordChangeCondo)
	
	txtSignPasswordChangeCondo = native.newTextField( intW/2, lastY, 300, 60 )
    txtSignPasswordChangeCondo.inputType = "password"
    txtSignPasswordChangeCondo.hasBackground = false
	txtSignPasswordChangeCondo.isSecure = true
	txtSignPasswordChangeCondo.placeholder = "CONTRASEÑA"
	txtSignPasswordChangeCondo:setTextColor( 64/255, 90/255, 139/255 )
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtSignPasswordChangeCondo.size = 20
	groupChangeCondo:insert(txtSignPasswordChangeCondo)
	
	lastY = intH/1.3
	
	local poscC = bodyChangeCombo.contentWidth + (intW - intW/1.2) / 2 - 30
	local poscC2 = (intH - intH/1.4) / 2 + 30
	
	local btnCancelChangeCondo = display.newRect( poscC, poscC2, 60, 60 )
	btnCancelChangeCondo:setFillColor( 43/255, 66/255, 116/255 )
	groupChangeCondo:insert(btnCancelChangeCondo)
	btnCancelChangeCondo:addEventListener( 'tap', hideChangeCombo)
	
	local imgArrowBackReturn = display.newImage( "img/btn/CANCELAR.png" )
	imgArrowBackReturn.x = poscC
	imgArrowBackReturn.y = poscC2
	groupChangeCondo:insert(imgArrowBackReturn)
	
	local paint = {
		type = "gradient",
		color1 = { 49/255, 187/255, 40/255 },
		color2 = { 45/255, 161/255, 45/255, 0.9 },
		direction = "down"
	}
	
	local btnAceptChangeCondo = display.newRoundedRect( intW/2, lastY, 200, 70, 10 )
	btnAceptChangeCondo:setFillColor( 51/255, 176/255, 46/255 )
	groupChangeCondo:insert(btnAceptChangeCondo)
	btnAceptChangeCondo.fill = paint
	btnAceptChangeCondo:addEventListener( 'tap', changeCondo)
	--btnAceptChangeCondo:addEventListener( 'tap', signOut)
	
	local labelAceptChangeCondo = display.newText( {   
        x = intW/2, y = lastY,
        text = "ACEPTAR",  font = fontDefault, fontSize = 28
	})
	labelAceptChangeCondo:setFillColor( 1 )
	groupChangeCondo:insert(labelAceptChangeCondo)
	
	loginGuardScreen:toFront()
	groupChangeCondo:toFront();
	
	return true

end

--escondel el formulario para cambiar de condominio
function hideChangeCombo( event )
	if txtSignPasswordChangeCondo then
		txtSignPasswordChangeCondo:removeSelf()
		txtSignPasswordChangeCondo = nil
	end
	loginGuardScreen:toBack()
	txtSignPasswordGuard.x = 335
	groupChangeCondo:removeSelf()
	groupChangeCondo = nil
	groupChangeCondo = display.newGroup()
	return true
end

--desactiva las funciones de tap y touch
function noAction( event )
	return true
end

--seleciona un guardia
function SelecGuard( event )
	btnSignLoginGuard.alpha = 1
	
	if currentGuard == nil then
		currentGuard = 1
	end
	
	GuardCondo[currentGuard].alpha = 1
	
	event.target.alpha = .5
	
	currentGuard = event.target.num
	
	return true
end

--funciones del teclado
function onTxtFocusLoginGuard(  event )
	
	if ( event.phase == "began" ) then
		groupInfoGuard.y = -20
		groupPassScreen.y = - 35

    elseif ( event.phase == "ended" ) then
		native.setKeyboardFocus( nil )
		groupInfoGuard.y = 0
		groupPassScreen.y = 0
    elseif ( event.phase == "submitted" ) then
		native.setKeyboardFocus( nil )
		groupInfoGuard.y = 0
		groupPassScreen.y = 0

    elseif event.phase == "editing" then
		
    end
	
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

function scene:create( event )

	screen = self.view
	
	screen:insert(loginGuardScreen)
	screen:insert(groupInfoGuard)
	screen:insert(groupPassScreen)
	
	local bgLogin = display.newRect( intW/2, h, intW, intH )
    bgLogin.fill = { type="image", filename="img/btn/fillPattern.jpg" }
	bgLogin.anchorY = 0
	loginGuardScreen:insert(bgLogin)
	
	local bgImgGuard = display.newRoundedRect( intW/2, h + 30, intW - 50, 200, 5 )
	bgImgGuard.anchorY = 0
	bgImgGuard:setFillColor( 6/255, 58/255, 98/255 )
	bgImgGuard.strokeWidth = 4
	bgImgGuard:setStrokeColor( 54/255, 80/255, 131/255 )
	groupInfoGuard:insert(bgImgGuard)
	
	local bgFieldPassword = display.newRoundedRect( intW/2, h + 250, intW - 50, 200, 5 )
	bgFieldPassword.anchorY = 0
	bgFieldPassword:setFillColor( 6/255, 58/255, 98/255 )
	bgFieldPassword.strokeWidth = 4
	bgFieldPassword:setStrokeColor( 54/255, 80/255, 131/255 )
	groupPassScreen:insert(bgFieldPassword)
	
	--lista de guardias
	
	local lastY = h + 65
	
	--local nameGuarda = {'Guardia'}
	
	--local groupGuardList = display.newGroup()]]
	
	--[[for i = 1, 4, 1 do
	
		GuardCondo[i] = display.newContainer( 135, 135 )
		GuardCondo[i].x = intW/5.7 * i - 50
		GuardCondo[i].y = lastY
		GuardCondo[i].id = i
		GuardCondo[i].num = i
		loginGuardScreen:insert(GuardCondo[i])
		GuardCondo[i]:addEventListener( 'tap', SelecGuard )
		
		bgImgGuard = display.newRoundedRect( 0, 0, 135, 135, 10 )
		bgImgGuard:setFillColor( 1 )
		GuardCondo[i]:insert(bgImgGuard)
		
		local imgGuard = display.newImage( "img/btn/GUARDIA.png" )
		imgGuard.x = 0
		imgGuard.y = 0
		GuardCondo[i]:insert(imgGuard)
	
	end]]
	
	labelTextPasswordGuard = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/2, y = lastY, width = intW - 100,
        text = "1. Selecciona tu usuario para iniciar:",  font = fontLatoBold, fontSize = 32, align = "left"
	})
	labelTextPasswordGuard:setFillColor( 1 )
	groupInfoGuard:insert(labelTextPasswordGuard)
	
	--btn view more
	
	--[[local btnViewMore = display.newRoundedRect( intW/1.14, lastY, 135, 135, 10 )
	btnViewMore:setFillColor( 1 )
	loginGuardScreen:insert(btnViewMore)
	
	local labelViewMore = display.newText( {   
        x = intW/1.14, y = lastY + 40,
        text = "Ver mas",  font = fontDefault, fontSize = 20
	})
	labelViewMore:setFillColor( 206/255, 68/255, 68/255 )
	loginGuardScreen:insert(labelViewMore)
	
	local imgViewMore = display.newImage( "img/btn/BUSCAR.png" )
	imgViewMore.x = intW/1.14
	imgViewMore.y = lastY - 20
	loginGuardScreen:insert(imgViewMore)]]
	
	--compo contraseña guardia
	
	lastY = h + 285
	
	labelTextPasswordGuard = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/2, y = lastY, width = intW - 100,
        text = "2. Introduce tu contraseña asignada",  font = fontLatoBold, fontSize = 32, align = "left"
	})
	labelTextPasswordGuard:setFillColor( 1 )
	groupPassScreen:insert(labelTextPasswordGuard)
	
	local bgTextPasswordGuard = display.newRoundedRect( 300, lastY + 85, 350, 60, 10 )
	bgTextPasswordGuard:setFillColor( 1 )
	bgTextPasswordGuard.strokeWidth = 2
	bgTextPasswordGuard:setStrokeColor( 54/255, 80/255, 131/255 )
	groupPassScreen:insert(bgTextPasswordGuard)
	
	local imgTextFieldPassword = display.newImage( "img/btn/icono-password.png" )
	imgTextFieldPassword.y = lastY + 85
	imgTextFieldPassword.x =  160
	groupPassScreen:insert(imgTextFieldPassword)
	
	txtSignPasswordGuard = native.newTextField( 335, lastY + 85, 280, 60 )
    txtSignPasswordGuard.inputType = "password"
    txtSignPasswordGuard.hasBackground = false
	txtSignPasswordGuard.placeholder = "Contraseña"
	txtSignPasswordGuard.isSecure = true
	txtSignPasswordGuard:setTextColor( 64/255, 90/255, 139/255 )
	txtSignPasswordGuard:addEventListener( "userInput", onTxtFocusLoginGuard )
	--txtSignEmail:setReturnKey(  "next"  )
	txtSignPasswordGuard.size = 20
	groupPassScreen:insert(txtSignPasswordGuard)
	
	-----botones---
	
	lastY = lastY + 85
	
	local paint = {
		type = "gradient",
		color1 = { 49/255, 187/255, 40/255 },
		color2 = { 45/255, 161/255, 45/255, 0.9 },
		direction = "down"
	}
	
	btnSignLoginGuard = display.newRoundedRect( 600, lastY + 1, 200, 70, 10 )
	btnSignLoginGuard:setFillColor( 51/255, 176/255, 46/255 )
	groupPassScreen:insert(btnSignLoginGuard)
	btnSignLoginGuard.fill = paint
	--btnSignLoginGuard.alpha = .3
	btnSignLoginGuard:addEventListener( 'tap', doSignInGuard)
	
	
	local labelSignLoginGuard = display.newText( {   
        x = 585, y = lastY,
        text = "ENTRAR",  font = fontLatoRegular, fontSize = 28
	})
	labelSignLoginGuard:setFillColor( 1 )
	groupPassScreen:insert(labelSignLoginGuard)
	
	local imgSignLogin = display.newImage( "img/btn/loginGuardias-iconoEntrar.png" )
	imgSignLogin.y = lastY
	imgSignLogin.x =  680
	groupPassScreen:insert(imgSignLogin)
	
	
	
	lastY = 515
	
	local labelNoPasswordLoginG = display.newText( {   
        x = intW/2, y = lastY, width = intW - 100,
        text = "En caso de no contar con esos datos, favor de comunicarse a administración",  font = fontLatoLight, fontSize = 22
	})
	labelNoPasswordLoginG:setFillColor( .2 )
	loginGuardScreen:insert(labelNoPasswordLoginG)
	
	local imgSignOut = display.newImage( "img/btn/loginGuardias-iconoSalir.png" )
	imgSignOut.x = 50
	imgSignOut.y = intH - 60
	loginGuardScreen:insert(imgSignOut)
	imgSignOut:addEventListener( 'tap', showChangeCondo)
	
	local labelSignOut = display.newText( {   
        x = 140, y = intH - 60,
        text = "SALIR",  font = fontLatoBold, fontSize = 30
	})
	labelSignOut:setFillColor( 5/255, 44/255, 77/255 )
	loginGuardScreen:insert(labelSignOut)
	labelSignOut:addEventListener( 'tap', showChangeCondo)
	
	DBManager.updateGuardActive()
	
	buildItemsGuard()

end

-- "scene:show()"
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		
	end
end

-- "scene:hide()"
function scene:hide( event )

	native.setKeyboardFocus( nil )

	local phase = event.phase

	if ( phase == "will" ) then
		
		if txtSignPasswordGuard then txtSignPasswordGuard:removeSelf() txtSignPasswordGuard = nil end
		if txtSignPasswordChangeCondo then txtSignPasswordChangeCondo:removeSelf() txtSignPasswordChangeCondo = nil end
	end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene