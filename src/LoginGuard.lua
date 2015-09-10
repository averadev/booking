-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login Guardia
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
local Globals = require('src.resources.Globals')
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local settings = DBManager.getSettings()

-------variables
--grupos
local loginGuardScreen = display.newGroup()
local groupChangeCondo = display.newGroup()

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

local itemsGuard

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

function gotoHome(idGuard)
	Globals.idGuard = idGuard
	composer.removeScene("src.Home")
	composer.gotoScene("src.Home")
end

function setItemsGuard(items)
	itemsGuard = items
	if #itemsGuard > 0 then
		LoadImageGuard(1)
	end
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
				buildItemsGuard()
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
						buildItemsGuard()
					end
				--end
			end
		end
		-- Descargamos de la nube
		display.loadRemoteImage( settings.url..itemsGuard[posc].path..itemsGuard[posc].foto, 
		"GET", loadImageListener, itemsGuard[posc].foto, system.TemporaryDirectory )
	end
end

--crea los guardias
function buildItemsGuard()
	
	local lastY = intH/2.3
	
	--local nameGuarda = {'Guardia'}
	
	--local groupGuardList = display.newGroup()
	
	for i = 1, #itemsGuard, 1 do
	
		GuardCondo[i] = display.newContainer( 135, 135 )
		GuardCondo[i].x = intW/5.7 * i - 50
		GuardCondo[i].y = lastY
		GuardCondo[i].id = itemsGuard[i].id
		GuardCondo[i].num = i
		loginGuardScreen:insert(GuardCondo[i])
		GuardCondo[i]:addEventListener( 'tap', SelecGuard )
		
		bgImgGuard = display.newRoundedRect( 0, 0, 135, 135, 10 )
		bgImgGuard:setFillColor( 1 )
		GuardCondo[i]:insert(bgImgGuard)
		
		local imgGuard = display.newImage( itemsGuard[i].foto, system.TemporaryDirectory )
		imgGuard.x = 0
		imgGuard.y = 0
		imgGuard.height = 120
		imgGuard.width = 120
		GuardCondo[i]:insert(imgGuard)
		
		--[[local labelNameGuard = display.newText( {   
			x = intW/5.7 * i - 45, y = lastY + 85,
			text = itemsGuard[i].nombre,  font = fontDefault, fontSize = 24
		})
		labelNameGuard:setFillColor( 0 )
		loginGuardScreen:insert(labelNameGuard)]]
	
	end
	
end

function doSignInGuard( event )
	--[[if txtSignPasswordGuard.text ~= '' and currentGuard ~= nil then
		--RestManager.validateGuard(txtSignPasswordGuard.text,GuardCondo[currentGuard].id)
		RestManager.validateGuard('123',GuardCondo[currentGuard].id)
	else
		native.showAlert( "Booking", "Campos vacios", { "OK"})
	end]]
	
	composer.removeScene("src.Home")
	composer.gotoScene("src.Home")
	
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
	else
		native.showAlert( "Booking", "Campos vacios", { "OK"})
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
	
	local bodyChangeCombo = display.newRect( intW/2, intH/2, intW/1.2, intH/1.4 + h )
	bodyChangeCombo:setFillColor( 54/255, 80/255, 131/255 )
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
	
	--[[local btnCancelChangeCondo = display.newRoundedRect( intW/2 - 180, lastY, 200, 70, 10 )
	btnCancelChangeCondo:setFillColor( 205/255, 69/255, 69/255 )
	groupChangeCondo:insert(btnCancelChangeCondo)
	btnCancelChangeCondo:addEventListener( 'tap', hideChangeCombo)
	
	local labelCancelChangeCondo = display.newText( {   
        x = intW/2 - 180, y = lastY,
        text = "CANCELAR",  font = fontDefault, fontSize = 28
	})
	labelCancelChangeCondo:setFillColor( 1 )
	groupChangeCondo:insert(labelCancelChangeCondo)]]
	
	local imgArrowBackReturn = display.newImage( "img/btn/CANCELAR.png" )
	imgArrowBackReturn.x = intH/2 + 535
	imgArrowBackReturn.y = h + 70
	groupChangeCondo:insert(imgArrowBackReturn)
	imgArrowBackReturn:addEventListener( 'tap', hideChangeCombo)
	
	local btnAceptChangeCondo = display.newRoundedRect( intW/2, lastY, 200, 70, 10 )
	btnAceptChangeCondo:setFillColor( 205/255, 69/255, 69/255 )
	groupChangeCondo:insert(btnAceptChangeCondo)
	--btnAceptChangeCondo:addEventListener( 'tap', changeCondo)
	btnAceptChangeCondo:addEventListener( 'tap', signOut)
	
	local labelAceptChangeCondo = display.newText( {   
        x = intW/2, y = lastY,
        text = "ACEPTAR",  font = fontDefault, fontSize = 28
	})
	labelAceptChangeCondo:setFillColor( 1 )
	groupChangeCondo:insert(labelAceptChangeCondo)
	
	return true

end

--escondel el formulario para cambiar de condominio
function hideChangeCombo( event )
	if txtSignPasswordChangeCondo then
		txtSignPasswordChangeCondo:removeSelf()
		txtSignPasswordChangeCondo = nil
	end
	txtSignPasswordGuard.x = intW/2
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

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

function scene:create( event )

	screen = self.view
	
	screen:insert(loginGuardScreen)
	
	local bgLogin = display.newRect( 0, h, intW, intH )
	bgLogin.anchorX = 0
	bgLogin.anchorY = 0
	bgLogin:setFillColor( 222/255, 222/255, 222/255 )
	loginGuardScreen:insert(bgLogin)
	
	local imgLogo = display.newCircle( intW/2, h + 110, 90 )
	imgLogo:setFillColor( 1 )
	loginGuardScreen:insert(imgLogo)
	
	local bgfringeDown = display.newRect( 0, intH - 20, intW, 20 )
	bgfringeDown.anchorX = 0
	bgfringeDown.anchorY = 0
	bgfringeDown:setFillColor( 96/255, 96/255, 96/255 )
	loginGuardScreen:insert(bgfringeDown)
	
	local bgfringeBtn = display.newRect( 0, intH - 210, intW, 190 )
	bgfringeBtn.anchorX = 0
	bgfringeBtn.anchorY = 0
	bgfringeBtn:setFillColor( 54/255, 80/255, 131/255 )
	loginGuardScreen:insert(bgfringeBtn)
	
	local bgfringePass = display.newRect( 0, intH - 330, intW, 120 )
	bgfringePass.anchorX = 0
	bgfringePass.anchorY = 0
	bgfringePass:setFillColor( 1 )
	loginGuardScreen:insert(bgfringePass)
	
	--lista de guardias
	
	local lastY = intH/2.3
	
	--local nameGuarda = {'Guardia'}
	
	--local groupGuardList = display.newGroup()
	
	for i = 1, 4, 1 do
	
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
	
	end
	
	--btn view more
	
	local btnViewMore = display.newRoundedRect( intW/1.14, lastY, 135, 135, 10 )
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
	loginGuardScreen:insert(imgViewMore)
	
	--compo contraseña guardia
	
	lastY = intH/1.54
	
	local bgTextPasswordGuard = display.newRoundedRect( intW/2, lastY, 300, 60, 10 )
	bgTextPasswordGuard:setFillColor( 1 )
	bgTextPasswordGuard.strokeWidth = 2
	bgTextPasswordGuard:setStrokeColor( 54/255, 80/255, 131/255 )
	loginGuardScreen:insert(bgTextPasswordGuard)
	
	txtSignPasswordGuard = native.newTextField( intW/2, lastY, 300, 60 )
    txtSignPasswordGuard.inputType = "password"
    txtSignPasswordGuard.hasBackground = false
	txtSignPasswordGuard.placeholder = "Contraseña"
	txtSignPasswordGuard.isSecure = true
	txtSignPasswordGuard:setTextColor( 64/255, 90/255, 139/255 )
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtSignPasswordGuard.size = 20
	loginGuardScreen:insert(txtSignPasswordGuard)
	
	local imgCleanPassword = display.newImage( "img/btn/CANCELAR.png" )
	imgCleanPassword.x = intW/2 + 200
	imgCleanPassword.y = lastY
	imgCleanPassword.height = 60
	imgCleanPassword.width = 60
	loginGuardScreen:insert(imgCleanPassword)
	
	-----botones---
	
	lastY = 600 + h
	
	btnSignLoginGuard = display.newRoundedRect( intW/2, lastY, 200, 70, 10 )
	btnSignLoginGuard:setFillColor( 205/255, 69/255, 69/255 )
	loginGuardScreen:insert(btnSignLoginGuard)
	--btnSignLoginGuard.alpha = .3
	btnSignLoginGuard:addEventListener( 'tap', doSignInGuard)
	
	local labelSignLoginGuard = display.newText( {   
        x = intW/2, y = lastY,
        text = "ACEPTAR",  font = fontDefault, fontSize = 28
	})
	labelSignLoginGuard:setFillColor( 1 )
	loginGuardScreen:insert(labelSignLoginGuard)
	
	local imgSignOut = display.newImage( "img/btn/SALIR.png" )
	imgSignOut.x = 100
	imgSignOut.y = 60 + h
	loginGuardScreen:insert(imgSignOut)
	imgSignOut:addEventListener( 'tap', showChangeCondo)
	
	--RestManager.getInfoGuard()

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