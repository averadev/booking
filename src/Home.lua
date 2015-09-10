-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

--variables
local homeScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont

----elementos
local btnAceptOptionn
local btnMessageAdmi
local btnRecordVisits

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

--regresa al la pantalla de login del guardia
function returnLoginGuard( event )
	composer.removeScene("src.LoginGuard")
	composer.gotoScene("src.LoginGuard")
end

function aceptOptionHome( event )

	if event.target.option == 1 then
		composer.removeScene("src.MessageAdmin")
		composer.gotoScene("src.MessageAdmin")
	elseif event.target.option == 2 then
		composer.removeScene("src.RecordVisit")
		composer.gotoScene("src.RecordVisit")
	end
	
	return true
	
end

--seleciona la opcion del guardia
function selectOptionHome( event )

	btnAceptOptionn:removeEventListener( 'tap', aceptOptionHome)
	
	if event.target.option == 1 then
		btnMessageAdmi.alpha = .7
		btnRecordVisits.alpha = 1
		
	elseif event.target.option == 2 then
		btnRecordVisits.alpha = .7
		btnMessageAdmi.alpha = 1
	end
	
	btnAceptOptionn.alpha = 1
	btnAceptOptionn.option = event.target.option
	btnAceptOptionn:addEventListener( 'tap', aceptOptionHome)
	
	return true
	
end
	

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(homeScreen)
	
	local bgLogin = display.newRect( 0, h, intW, intH )
	bgLogin.anchorX = 0
	bgLogin.anchorY = 0
	bgLogin:setFillColor( 222/255, 222/255, 222/255 )
	homeScreen:insert(bgLogin)
	
	local imgLogo = display.newCircle( intW/2, h + 110, 90 )
	imgLogo:setFillColor( 1 )
	homeScreen:insert(imgLogo)
	
	local bgfringeDown = display.newRect( 0, intH - 20, intW, 20 )
	bgfringeDown.anchorX = 0
	bgfringeDown.anchorY = 0
	bgfringeDown:setFillColor( 96/255, 96/255, 96/255 )
	homeScreen:insert(bgfringeDown)
	
	local bgfringeField = display.newRect( 0, h + 240, intW, 300 )
	bgfringeField.anchorX = 0
	bgfringeField.anchorY = 0
	bgfringeField:setFillColor( 54/255, 80/255, 131/255 )
	homeScreen:insert(bgfringeField)
	
	btnMessageAdmi = display.newRoundedRect( intW/3.5, h + intH/2 + 5, 200, 200, 12 )
	btnMessageAdmi.option = 1
	btnMessageAdmi:setFillColor( 1 )
	homeScreen:insert(btnMessageAdmi)
	btnMessageAdmi:addEventListener( 'tap', selectOptionHome )
	
	local imgMessageAdmi = display.newImage( "img/btn/VERSION2MENSAJE.png" )
	imgMessageAdmi.x =	intW/3.5
	imgMessageAdmi.y = h + intH/2 - 25
	homeScreen:insert(imgMessageAdmi)
	
	local labelMessageAdmi = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/3.5, y = h + intH/2 + 70, width = 200,
        text = "MENSAJE DE ADMINISTRACION",  font = fontDefault, fontSize = 19, align = "center",
	})
	labelMessageAdmi:setFillColor( 64/255, 90/255, 139/255 )
	homeScreen:insert(labelMessageAdmi)
	
	btnRecordVisits = display.newRoundedRect( intW/1.4, h + intH/2 + 5, 200, 200, 12 )
	btnRecordVisits.option = 2
	btnRecordVisits:setFillColor( 1 )
	homeScreen:insert(btnRecordVisits)
	btnRecordVisits:addEventListener( 'tap', selectOptionHome )
	
	local imgMessageAdmi = display.newImage( "img/btn/VERSION2REGISTRO.png" )
	imgMessageAdmi.x =	intW/1.4
	imgMessageAdmi.y = h + intH/2 - 25
	homeScreen:insert(imgMessageAdmi)
	
	local labelRecordVisits = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/1.4, y = h + intH/2 + 70, width = 200,
        text = "REGISTRO DE VISITAS",  font = fontDefault, fontSize = 19, align = "center",
	})
	labelRecordVisits:setFillColor( 64/255, 90/255, 139/255 )
	homeScreen:insert(labelRecordVisits)
	
	--botones
	
	lastY = 600 + h
	
	
	
	local btnCancelHome = display.newRoundedRect( intW/2 - 150, lastY, 200, 70, 10 )
	btnCancelHome:setFillColor( 205/255, 69/255, 69/255 )
	homeScreen:insert(btnCancelHome)
	btnCancelHome:addEventListener( 'tap', returnLoginGuard)
	
	local labelCancelHome = display.newText( {   
        x = intW/2 - 150, y = lastY,
        text = "CANCELAR",  font = fontDefault, fontSize = 28
	})
	labelCancelHome:setFillColor( 1 )
	homeScreen:insert(labelCancelHome)
	
	btnAceptOptionn = display.newRoundedRect( intW/2 + 150, lastY, 200, 70, 10 )
	btnAceptOptionn:setFillColor( 64/255, 90/255, 139/255 )
	btnAceptOptionn.option = 0
	btnAceptOptionn.alpha = .3
	homeScreen:insert(btnAceptOptionn)
	--btnSignLogin:addEventListener( 'tap', doSignIn)
	
	local labelAceptOption = display.newText( {   
        x = intW/2 + 150, y = lastY,
        text = "ACEPTAR",  font = fontDefault, fontSize = 28
	})
	labelAceptOption:setFillColor( 1 )
	homeScreen:insert(labelAceptOption)
   
end

-- "scene:show()"
function scene:show( event )
	
end

-- "scene:hide()"
function scene:hide( event )
   local phase = event.phase
   --phase == "will"
   --phase == "did"
end

-- "scene:destroy()"
function scene:destroy( event )
	
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene