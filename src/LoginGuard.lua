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
	
		GuardCondo[i] = display.newImage( itemsGuard[i].foto, system.TemporaryDirectory )
		GuardCondo[i].x = intW/5.7 * i - 50
		GuardCondo[i].y = lastY
		GuardCondo[i].height = 120
		GuardCondo[i].width = 120
		GuardCondo[i].id = itemsGuard[i].id
		GuardCondo[i].num = i
		loginGuardScreen:insert(GuardCondo[i])
		GuardCondo[i]:addEventListener( 'tap', SelecGuard )
		
		local labelNameGuard = display.newText( {   
			x = intW/5.7 * i - 45, y = lastY + 85,
			text = itemsGuard[i].nombre,  font = fontDefault, fontSize = 24
		})
		labelNameGuard:setFillColor( 0 )
		loginGuardScreen:insert(labelNameGuard)
	
	end
	
end

function doSignInGuard( event )
	if txtSignPasswordGuard.text ~= '' and currentGuard ~= nil then
		RestManager.validateGuard(txtSignPasswordGuard.text,GuardCondo[currentGuard].id)
	else
		native.showAlert( "Booking", "La contraseña esta vacia", { "OK"})
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
	else
		native.showAlert( "Booking", "La contraseña esta vacia", { "OK"})
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
	bodyChangeCombo:setFillColor( 1 )
	groupChangeCondo:insert(bodyChangeCombo)
	bodyChangeCombo:addEventListener( 'tap', noAction )
	
	local labelLegend = "Para cambiar el condominio asignado es necesario introducir la contraseña del administrador"
	
	local labellegendChangeCondo = display.newText( {   
        x = intW/2, y = intH/4 + h,
		width = bodyChangeCombo.contentWidth - 100,
        text = labelLegend,  font = fontDefault, fontSize = 36, align = "center"
	})
	labellegendChangeCondo:setFillColor( 0 )
	groupChangeCondo:insert(labellegendChangeCondo)
	
	lastY = intH/1.8
	
	local labelPasswordGuard = display.newText( {   
        x = intW/2 - 150, y = lastY,
		width = 200,
        text = "Contraseña: ",  font = fontDefault, fontSize = 32
	})
	labelPasswordGuard:setFillColor( 0 )
	groupChangeCondo:insert(labelPasswordGuard)
	
	local bgTextPasswordChangeCondo = display.newRect( intW/2 + 150, lastY, 300, 60 )
	bgTextPasswordChangeCondo:setFillColor( .8 )
	groupChangeCondo:insert(bgTextPasswordChangeCondo)
	
	txtSignPasswordChangeCondo = native.newTextField( intW/2 + 150, lastY, 300, 60 )
    txtSignPasswordChangeCondo.inputType = "password"
    txtSignPasswordChangeCondo.hasBackground = false
	txtSignPasswordChangeCondo.isSecure = true
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtSignPasswordChangeCondo.size = 20
	groupChangeCondo:insert(txtSignPasswordChangeCondo)
	
	lastY = intH/1.4
	
	local btnCancelChangeCondo = display.newRect( intW/2 - 120, lastY, 200, 65 )
	btnCancelChangeCondo:setFillColor( 1, 0, 0 )
	groupChangeCondo:insert(btnCancelChangeCondo)
	btnCancelChangeCondo:addEventListener( 'tap', hideChangeCombo)
	
	local labelCancelChangeCondo = display.newText( {   
        x = intW/2 - 120, y = lastY,
        text = "Cancelar",  font = fontDefault, fontSize = 28
	})
	labelCancelChangeCondo:setFillColor( 1 )
	groupChangeCondo:insert(labelCancelChangeCondo)
	
	local btnAceptChangeCondo = display.newRect( intW/2 + 120, lastY, 200, 65 )
	btnAceptChangeCondo:setFillColor( 0, 0, 1 )
	groupChangeCondo:insert(btnAceptChangeCondo)
	btnAceptChangeCondo:addEventListener( 'tap', changeCondo)
	
	local labelAceptChangeCondo = display.newText( {   
        x = intW/2 + 120, y = lastY,
        text = "Aceptar",  font = fontDefault, fontSize = 28
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
	txtSignPasswordGuard.x = intW/2 + 150
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
	bgLogin:setFillColor( 214/255, 226/255, 225/255 )
	loginGuardScreen:insert(bgLogin)
	
	local imgLogo = display.newRect( intW/2, h + 100, 150, 150 )
	imgLogo:setFillColor( 0 )
	loginGuardScreen:insert(imgLogo)
	
	--lista de guardias
	
	local lastY = intH/2.3
	
	--local nameGuarda = {'Guardia'}
	
	--local groupGuardList = display.newGroup()
	
	--[[for i = 1, 4, 1 do
	
		GuardCondo[i] = display.newImage( "img/btn/avatarUser.png" )
		GuardCondo[i].x = intW/5.7 * i - 50
		GuardCondo[i].y = lastY
		GuardCondo[i].height = 120
		GuardCondo[i].width = 120
		GuardCondo[i].id = i
		GuardCondo[i].num = i
		loginGuardScreen:insert(GuardCondo[i])
		GuardCondo[i]:addEventListener( 'tap', SelecGuard )
		
		local labelNameGuard = display.newText( {   
			x = intW/5.7 * i - 45, y = lastY + 85,
			text = "Guardia" .. i ,  font = fontDefault, fontSize = 24
		})
		labelNameGuard:setFillColor( 0 )
		loginGuardScreen:insert(labelNameGuard)
	
	end]]
	
	--btn view more
	
	local btnViewMore = display.newRect( intW/1.14, lastY, 120, 120 )
	btnViewMore:setFillColor( .8 )
	loginGuardScreen:insert(btnViewMore)
	
	local labelViewMore = display.newText( {   
        x = intW/1.14, y = lastY + 80,
        text = "Ver mas",  font = fontDefault, fontSize = 24
	})
	labelViewMore:setFillColor( 0 )
	loginGuardScreen:insert(labelViewMore)
	
	local imgViewMore = display.newImage( "img/btn/iconSearch.png" )
	imgViewMore.x = intW/1.14
	imgViewMore.y = lastY
	imgViewMore.height = 65
	imgViewMore.width = 65
	loginGuardScreen:insert(imgViewMore)
	
	--compo contraseña guardia
	
	lastY = intH/1.5
	
	local labelPasswordGuard = display.newText( {   
        x = intW/2 - 150, y = lastY,
		width = 200,
        text = "Contraseña: ",  font = fontDefault, fontSize = 32
	})
	labelPasswordGuard:setFillColor( 0 )
	loginGuardScreen:insert(labelPasswordGuard)
	
	local bgTextPasswordGuard = display.newRect( intW/2 + 150, lastY, 300, 60 )
	bgTextPasswordGuard:setFillColor( 1 )
	loginGuardScreen:insert(bgTextPasswordGuard)
	
	txtSignPasswordGuard = native.newTextField( intW/2 + 150, lastY, 300, 60 )
    txtSignPasswordGuard.inputType = "password"
    txtSignPasswordGuard.hasBackground = false
	txtSignPasswordGuard.isSecure = true
 -- txtSignEmail:addEventListener( "userInput", onTxtFocus )
	--txtSignEmail:setReturnKey(  "next"  )
	txtSignPasswordGuard.size = 20
	loginGuardScreen:insert(txtSignPasswordGuard)
	
	-----botones---
	
	lastY = intH/1.25
	
	local btnCancelLoginGuard = display.newRect( intW/2 - 120, lastY, 200, 65 )
	btnCancelLoginGuard:setFillColor( 1, 0, 0 )
	loginGuardScreen:insert(btnCancelLoginGuard)
	
	local labelCancelLoginGuard = display.newText( {   
        x = intW/2 - 120, y = lastY,
        text = "Cancelar",  font = fontDefault, fontSize = 28
	})
	labelCancelLoginGuard:setFillColor( 1 )
	loginGuardScreen:insert(labelCancelLoginGuard)
	
	btnSignLoginGuard = display.newRect( intW/2 + 120, lastY, 200, 65 )
	btnSignLoginGuard:setFillColor( 0, 0, 1 )
	loginGuardScreen:insert(btnSignLoginGuard)
	btnSignLoginGuard.alpha = .3
	btnSignLoginGuard:addEventListener( 'tap', doSignInGuard)
	
	local labelSignLoginGuard = display.newText( {   
        x = intW/2 + 120, y = lastY,
        text = "Aceptar",  font = fontDefault, fontSize = 28
	})
	labelSignLoginGuard:setFillColor( 1 )
	loginGuardScreen:insert(labelSignLoginGuard)
	
	local btnChangeCondo = display.newRect( intW - 215, intH - 50, 370, 60 )
	btnChangeCondo:setFillColor( .2 )
	loginGuardScreen:insert(btnChangeCondo)
	btnChangeCondo:addEventListener( 'tap', showChangeCondo)
	
	local labelChangeCodo = display.newText( {   
        x = intW - 215, y = intH - 50,
        text = "Cambiar de comdominio",  font = fontDefault, fontSize = 28
	})
	labelChangeCodo:setFillColor( 1 )
	loginGuardScreen:insert(labelChangeCodo)
	
	RestManager.getInfoGuard()

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