-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
require('src.BuildItem')
local widget = require( "widget" )
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
local scene = composer.newScene()

local settings = DBManager.getSettings()

--variables
local loginScreen = display.newGroup()
local groupOptionCombo = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

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

----elementos
--texto
local labelComboOpcionCity
--native textField
local txtSignEmail, txtSignPassword
--scroll
local svOptionCombo
--local itemsCity = {'Cancun', 'Merida', 'Chetumal', 'Villahermosa', 'tuxtla', 'Narnia'}
local itemsCity
local itemsGuard

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

function setItemsCity(items)
	itemsCity = items
end

function setItemsGuard(items)
	itemsGuard = items
	if #itemsGuard > 0 then
		LoadImageGuard(1)
	end
end

function gotoLoginGuard()

	deleteNewAlert()
	composer.removeScene( "src.LoginGuard" )
	composer.gotoScene( "src.LoginGuard" )
	
end

--funcion de logeo
function doSignIn( event )

	NewAlert("Booking","Comprobando usuario", 0)
	
	--RestManager.validateAdmin('','123','alfredo',1)
	if txtSignEmail.text == "" or txtSignPassword.text == "" then
		--native.showAlert( "Booking", "Los campos son requeridos.", { "OK"})
		local msgError = "Por favor Introduce los siguientes datos faltantes: "
		if txtSignEmail.text == "" then
			msgError = msgError .. "\nCorreo del administrador "
		end
		if txtSignPassword.text == "" then
			msgError = msgError .. "\n*Contraseña del administrador "
		end
		--[[if labelComboOpcionCity.id == 0 then
			msgError = msgError .. " \n*Ciudad del condominio"
		end]]
		
		NewAlert("Datos Faltantes", msgError, 1)
	else
		RestManager.validateAdmin(txtSignEmail.text, txtSignPassword.text)
		--RestManager.validateAdmin('alfredo.conomia@gmail.com','123')
	end
	
	--RestManager.validateAdmin('alfredo.conomia@gmail.com','123',labelComboOpcionCity.id)
	
	return true
end

--carga las imagenes de los guardias
function LoadImageGuard(posc)
	-- Determinamos si la imagen existe
	local path = system.pathForFile( itemsGuard[posc].foto, system.TemporaryDirectory )
	local fhd = io.open( path )
	if fhd then
		fhd:close()
		--if itemsGuard[posc].callback == Globals.noCallbackGlobal then
			--imageLogos[posc] = display.newImage( itemsGuard[posc].partnerImage, system.TemporaryDirectory )
			--imageLogos[posc].alpha = 0
			if posc < #itemsGuard then
				posc = posc + 1
				LoadImageGuard(posc)
			else
				gotoLoginGuard()
				--loadImage({posc = 1, screen = 'MainScreen'})
			end
		--end
	else
		-- Listener de la carga de la imagen del servidor
		local function loadImageListener( event )
			if ( event.isError ) then
				native.showAlert( "Go Deals", "Network error :(", { "OK"})
			else
				event.target.alpha = 0
				--if itemsGuard[posc].callback == Globals.noCallbackGlobal then
					--imageLogos[posc] = event.target
					if posc < #itemsGuard then
						posc = posc + 1
						LoadImageGuard(posc)
					else
						gotoLoginGuard()
					end
				--end
			end
		end
		-- Descargamos de la nube
		display.loadRemoteImage( settings.url..itemsGuard[posc].path..itemsGuard[posc].foto, 
		"GET", loadImageListener, itemsGuard[posc].foto, system.TemporaryDirectory )
	end
end

--obtiene el valor del combobox
function getOptionComboCity( event )

	labelComboOpcionCity.id = event.target.id
	labelComboOpcionCity.text = event.target.name
	
	hideComboBoxCity()
	return true
end

--llena las optiones del combobox
function setOptionComboCity()

	local city = {'Cancun', 'Merida', 'Chetumal', 'Villahermosa', 'tuxtla', 'Narnia'}
	local optionCity = {}

	local lastY = 30
	
	for i = 1, #itemsCity, 1 do
	
		--print(itemsCity[i].nombre)
		
		optionCity[i] = display.newRect( svOptionCombo.contentWidth/2, lastY, intW/2, 80 )
		optionCity[i]:setFillColor( 1 )
		optionCity[i].name = itemsCity[i].nombre
		optionCity[i].id = itemsCity[i].id
		svOptionCombo:insert(optionCity[i])
		optionCity[i]:addEventListener( 'tap', getOptionComboCity )
		
		local labelOpcion = display.newText( {
        text = itemsCity[i].nombre,
        x = svOptionCombo.contentWidth/2, y = lastY + 10, width = svOptionCombo.contentWidth - 40,
        font = fontDefault, fontSize = 28, align = "left"
		})
		labelOpcion:setFillColor( 0 )
		svOptionCombo:insert(labelOpcion)
		
		--optionCity[i]:addEventListener( 'tap', hideComboBoxCity )
	
		lastY = lastY + 80
		
	end
	
	local lastY2 = 80
	
	for i = 1, #itemsCity, 1 do
	
		if i ~= #itemsCity then
		
			local lineOptioCombo = display.newLine( 0, lastY2, svOptionCombo.contentWidth, lastY2 )
			lineOptioCombo:setStrokeColor( 0 )
			lineOptioCombo.strokeWidth = 2
			svOptionCombo:insert(lineOptioCombo)
		
			lastY2 = lastY2 + 80
		
		end
		
	end
	
	

end

--inicializa el combobox
function showComboBoxCity( event )

	txtSignEmail.x = - intW
	txtSignPassword.x = - intW

	groupOptionCombo:toFront()
	
	--groupOptionCombo
	local bgOptionCombo = display.newRect( 0, h, intW, intH )
	bgOptionCombo.anchorX = 0
	bgOptionCombo.anchorY = 0
	bgOptionCombo:setFillColor( 0 )
	bgOptionCombo.alpha = .5
	groupOptionCombo:insert(bgOptionCombo)
	bgOptionCombo:addEventListener( 'tap', hideComboBoxCity )
	
	local heightScroll = intH/2
	
	if #itemsCity < 5 then
		heightScroll = #itemsCity * 80
	end
	
	svOptionCombo = widget.newScrollView
	{
		x = intW/2,
		y = h + intH/2,
		width = intW/2,
		height = heightScroll,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		isBounceEnabled = true,
		backgroundColor = { 1 }
	}
	groupOptionCombo:insert(svOptionCombo)
	--svOptionCombo:toFront()
	svOptionCombo:addEventListener( 'tap', noAction)
	
	
	setOptionComboCity()
	
end

--esconde el combobox de ciudad
function hideComboBoxCity( event )
	txtSignEmail.x = intW/5 + 30
	txtSignPassword.x = intW/2 + 30
	groupOptionCombo:removeSelf()
	groupOptionCombo = nil
	groupOptionCombo = display.newGroup()
	return true
end

--anula los atributos de tap y touch
function noAction( event )
	return true
end

--evento de los textField
function onTxtFocusLogin( event )
	
	if ( event.phase == "began" ) then

    elseif ( event.phase == "ended" ) then
		native.setKeyboardFocus( nil )

    elseif ( event.phase == "submitted" ) then
		native.setKeyboardFocus( nil )
	
		--[[if event.target.name == "email" then
			native.setKeyboardFocus(txtSignPassword)
		elseif event.target.name == "password" then
			native.setKeyboardFocus( nil )
			SignIn()
		end]]

    elseif event.phase == "editing" then

    end
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

function scene:create( event )

	screen = self.view
	
	screen:insert(loginScreen)
	
	local bgLogin = display.newImage( "img/btn/fondo.png" )
	bgLogin.anchorX = 0
	bgLogin.anchorY = 0
	bgLogin.width = intW
	bgLogin.height = intH - h
	bgLogin.y = h
	loginScreen:insert(bgLogin)
	
	local lastY = 100 + h
	
	labelWelcomeLogin = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/3.5, y = lastY,
        text = "¡BIENVENIDO!",  font = fontLatoBold, fontSize = 60, align = "left"
	})
	labelWelcomeLogin:setFillColor( 1 )
	loginScreen:insert(labelWelcomeLogin)
	
	lastY = lastY + 75
	
	labelIdentifyLogin = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/3, y = lastY,
        text = "Antes de iniciar, por favor identificate:",  font = fontLatoLight, fontSize = 30, align = "left"
	})
	labelIdentifyLogin:setFillColor( 1 )
	loginScreen:insert(labelIdentifyLogin)
	
	--intW/2
	--intW/1.25
	
	local lastY = 250 + h
	
	------campos usuario
	
	local bgTextFieldUser = display.newRoundedRect( intW/5, lastY, 270, 60, 10 )
	bgTextFieldUser:setFillColor( 1 )
	bgTextFieldUser:setStrokeColor( 54/255, 80/255, 131/255 )
	bgTextFieldUser.strokeWidth = 2
	loginScreen:insert(bgTextFieldUser)
	
	local imgTextFieldUser = display.newImage( "img/btn/icono-user.png" )
	imgTextFieldUser.y = lastY
	imgTextFieldUser.x =  intW/5 - 100
	loginScreen:insert(imgTextFieldUser)
	
	txtSignEmail = native.newTextField( intW/5 + 30, lastY, 200, 60 )
    txtSignEmail.inputType = "email"
    txtSignEmail.hasBackground = false
	txtSignEmail.placeholder = "USUARIO"
	txtSignEmail:setTextColor( 64/255, 90/255, 139/255 )
	txtSignEmail:addEventListener( "userInput", onTxtFocusLogin )
	--txtSignEmail:setReturnKey(  "next"  )
	txtSignEmail.size = 24
	loginScreen:insert(txtSignEmail)
	
	-----campos password
	
	--lastY = intH/1.4
	
	local bgTextFieldPassword = display.newRoundedRect( intW/2, lastY, 270, 60, 10 )
	bgTextFieldPassword:setFillColor( 1 )
	bgTextFieldPassword:setStrokeColor( 54/255, 80/255, 131/255 )
	bgTextFieldPassword.strokeWidth = 2
	loginScreen:insert(bgTextFieldPassword)
	
	local imgTextFieldPassword = display.newImage( "img/btn/icono-password.png" )
	imgTextFieldPassword.y = lastY
	imgTextFieldPassword.x =  intW/2 - 100
	loginScreen:insert(imgTextFieldPassword)
	
	txtSignPassword = native.newTextField( intW/2 + 30, lastY, 200, 60 )
    txtSignPassword.inputType = "password"
    txtSignPassword.hasBackground = false
	txtSignPassword.placeholder = "CONTRASEÑA"
	txtSignPassword:setTextColor( 64/255, 90/255, 139/255 )
    txtSignPassword:addEventListener( "userInput", onTxtFocusLogin )
	--txtSignPassword:setReturnKey(  "go"  )
	txtSignPassword.isSecure = true
	txtSignPassword.size = 24
	loginScreen:insert(txtSignPassword)
	
	--combobox ciudad
	
	--[[local bgComboCity = display.newRoundedRect( intW/1.25, lastY, 270, 60, 10 )
	bgComboCity:setFillColor( 1 )
	loginScreen:insert(bgComboCity)
	bgComboCity:setStrokeColor( 54/255, 80/255, 131/255 )
	bgComboCity.strokeWidth = 2
	
	local imgTextFieldPassword = display.newImage( "img/btn/icono-ciudad.png" )
	imgTextFieldPassword.y = lastY
	imgTextFieldPassword.x =  intW/1.25 - 100
	loginScreen:insert(imgTextFieldPassword)
	
	local imgArrowDownCombo = display.newImage( "img/btn/optionCondo.png" )
	imgArrowDownCombo.x = intW/1.25 + 100
	imgArrowDownCombo.y = lastY
	imgArrowDownCombo.height = 30
	imgArrowDownCombo.width = 30
	loginScreen:insert(imgArrowDownCombo)
	imgArrowDownCombo:addEventListener( 'tap', showComboBoxCity)
	
	labelComboOpcionCity = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/1.25 + 30, y = lastY,
		width = 200,
        text = "CIUDAD",  font = fontDefault, fontSize = 20, align = "left"
	})
	labelComboOpcionCity:setFillColor( 204/255, 204/255, 204/255 )
	labelComboOpcionCity.id = 0
	loginScreen:insert(labelComboOpcionCity)]]
	
	-----botones---
	
	lastY = 380 + h
	
	local paint = {
		type = "gradient",
		color1 = { 49/255, 187/255, 40/255 },
		color2 = { 45/255, 161/255, 45/255, 0.9 },
		direction = "down"
	}
	
	local btnSignLogin = display.newRoundedRect( intW/5 + 165, lastY, 600, 70, 10 )
	btnSignLogin:setFillColor( 50/255, 175/255, 45/255 )
	loginScreen:insert(btnSignLogin)
	btnSignLogin:addEventListener( 'tap', doSignIn)
	btnSignLogin.fill = paint
	
	
	local labelSignLogin = display.newText( {   
        x = intW/5 - 50, y = lastY,
        text = "ENTRAR",  font = fontLatoRegular, fontSize = 28
	})
	labelSignLogin:setFillColor( 1 )
	loginScreen:insert(labelSignLogin)
	
	local imgSignLogin = display.newImage( "img/btn/loginGuardias-iconoEntrar.png" )
	imgSignLogin.y = lastY
	imgSignLogin.x =  intW/5 + 440
	loginScreen:insert(imgSignLogin)
	
	RestManager.getCity()

end

-- "scene:show()"
function scene:show( event )

end

-- "scene:hide()"
function scene:hide( event )

	native.setKeyboardFocus( nil )

	local phase = event.phase

	if ( phase == "will" ) then
		if txtSignEmail then
			txtSignEmail:removeSelf()
			txtSignPassword:removeSelf()
			txtSignEmail = nil
			txtSignPassword = nil
		end
	end
   --[[elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end]]
end

-- "scene:destroy()"
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene