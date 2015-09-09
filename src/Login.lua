-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

--variables
local loginScreen = display.newGroup()
local groupOptionCombo = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = "native.systemFont"

----elementos
--texto
local labelComboOpcionCity
--native textField
local txtSignEmail, txtSignPassword
--scroll
local svOptionCombo
local itemsCity

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

function setItemsCity(items)
	itemsCity = items
end

function gotoLoginGuard()

	composer.removeScene( "src.LoginGuard" )
	composer.gotoScene( "src.LoginGuard" )
	
end

--funcion de logeo
function doSignIn( event )
	
	--RestManager.validateAdmin('','123','alfredo',1)
	if txtSignEmail.text == "" or txtSignPassword.text == "" or labelComboOpcionCity.id == 0 then
		native.showAlert( "Booking", "Los campos son requeridos.", { "OK"})
	else
		--RestManager.validateAdmin(txtSignEmail.text, txtSignPassword.text, labelComboOpcionCity.id)
		RestManager.validateAdmin('alfredo.conomia@gmail.com','123',labelComboOpcionCity.id)
	end
	
	--RestManager.validateAdmin('alfredo.conomia@gmail.com','123',labelComboOpcionCity.id)
	
	return true
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
	txtSignEmail.x = intW/2 + 170
	txtSignPassword.x = intW/2 + 170
	groupOptionCombo:removeSelf()
	groupOptionCombo = nil
	groupOptionCombo = display.newGroup()
	return true
end

--anula los atributos de tap y touch
function noAction( event )
	return true
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

function scene:create( event )

	screen = self.view
	
	screen:insert(loginScreen)
	
	local bgLogin = display.newRect( 0, h, intW, intH )
	bgLogin.anchorX = 0
	bgLogin.anchorY = 0
	bgLogin:setFillColor( 214/255, 226/255, 225/255 )
	loginScreen:insert(bgLogin)
	
	local imgLogo = display.newRect( intW/2, h + 100, 150, 150 )
	imgLogo:setFillColor( 0 )
	loginScreen:insert(imgLogo)
	
	local lastY = intH/2.2
	
	--combobox ciudad
	
	local labelLoginCity = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/2 - 170, y = lastY,
		width = 200,
        text = "Ciudad:",  font = fontDefault, fontSize = 32,
	})
	labelLoginCity:setFillColor( 0 )
	loginScreen:insert(labelLoginCity)
	
	local bgComboCity = display.newRect( intW/2 + 170, lastY, 300, 60 )
	bgComboCity:setFillColor( 1 )
	loginScreen:insert(bgComboCity)
	bgComboCity:setStrokeColor( 0 )
	bgComboCity.strokeWidth = 2
	bgComboCity:addEventListener( 'tap', showComboBoxCity)
	
	local lineLeftComboCity = display.newRect( intW/2 + 260, lastY, 2, 60 )
	lineLeftComboCity:setFillColor( 0 )
	loginScreen:insert(lineLeftComboCity)
	
	local imgArrowDownCombo = display.newImage( "img/btn/arrowDownCombo.png" )
	imgArrowDownCombo.x = intW/2 + 290
	imgArrowDownCombo.y = lastY + 1
	imgArrowDownCombo.height = 70
	imgArrowDownCombo.width = 70
	loginScreen:insert(imgArrowDownCombo)
	
	labelComboOpcionCity = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/2 + 140, y = lastY,
		width = 200,
        text = "Seleccionar ciudad",  font = fontDefault, fontSize = 20, align = "left"
	})
	labelComboOpcionCity:setFillColor( 0 )
	labelComboOpcionCity.id = 0
	loginScreen:insert(labelComboOpcionCity)
	
	------campos usuario
	
	lastY = intH/1.7
	
	local labelLoginUser = display.newText( {   
        x = intW/2 - 170, y = lastY,
		width = 200,
        text = "Usuario:",  font = fontDefault, fontSize = 32
	})
	labelLoginUser:setFillColor( 0 )
	loginScreen:insert(labelLoginUser)
	
	local bgTextFieldUser = display.newRect( intW/2 + 170, lastY, 300, 60 )
	bgTextFieldUser:setFillColor( 1 )
	loginScreen:insert(bgTextFieldUser)
	
	txtSignEmail = native.newTextField( intW/2 + 170, lastY, 300, 60 )
    txtSignEmail.inputType = "email"
    txtSignEmail.hasBackground = false
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtSignEmail.size = 24
	loginScreen:insert(txtSignEmail)
	
	-----campos password
	
	lastY = intH/1.4
	
	local labelLoginPassword = display.newText( {   
        x = intW/2 - 170, y = lastY,
		width = 200,
        text = "Contraseña:",  font = fontDefault, fontSize = 32,
	})
	labelLoginPassword:setFillColor( 0 )
	loginScreen:insert(labelLoginPassword)
	
	local bgTextFieldPassword = display.newRect( intW/2 + 170, lastY, 300, 60 )
	bgTextFieldPassword:setFillColor( 1 )
	loginScreen:insert(bgTextFieldPassword)
	
	txtSignPassword = native.newTextField( intW/2 + 170, lastY, 300, 60 )
    txtSignPassword.inputType = "password"
    txtSignPassword.hasBackground = false
   -- txtSignPassword:addEventListener( "userInput", onTxtFocus )
	--txtSignPassword:setReturnKey(  "go"  )
	txtSignPassword.isSecure = true
	txtSignPassword.size = 24
	loginScreen:insert(txtSignPassword)
	
	-----botones---
	
	lastY = intH/1.15
	
	local btnCancelLogin = display.newRect( intW/2 - 120, lastY, 200, 65 )
	btnCancelLogin:setFillColor( 1, 0, 0 )
	loginScreen:insert(btnCancelLogin)
	
	local labelCancelLogin = display.newText( {   
        x = intW/2 - 120, y = lastY,
        text = "Cancelar",  font = fontDefault, fontSize = 28
	})
	labelCancelLogin:setFillColor( 1 )
	loginScreen:insert(labelCancelLogin)
	
	local btnSignLogin = display.newRect( intW/2 + 120, lastY, 200, 65 )
	btnSignLogin:setFillColor( 0, 0, 1 )
	loginScreen:insert(btnSignLogin)
	btnSignLogin:addEventListener( 'tap', doSignIn)
	
	local labelSignLogin = display.newText( {   
        x = intW/2 + 120, y = lastY,
        text = "Aceptar",  font = fontDefault, fontSize = 28
	})
	labelSignLogin:setFillColor( 1 )
	loginScreen:insert(labelSignLogin)
	
	RestManager.getCity()

end

-- "scene:show()"
function scene:show( event )

end

-- "scene:hide()"
function scene:hide( event )

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