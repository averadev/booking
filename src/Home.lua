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

fontDefault = "native.systemFont"

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
	bgLogin:setFillColor( 214/255, 226/255, 225/255 )
	homeScreen:insert(bgLogin)
	
	local imgLogo = display.newRect( intW/2, h + 100, 150, 150 )
	imgLogo:setFillColor( 0 )
	homeScreen:insert(imgLogo)
	
	btnMessageAdmi = display.newRect( intW/3.5, h + intH/2, intH/3, intH/3 )
	btnMessageAdmi.option = 1
	btnMessageAdmi:setFillColor( 1 )
	homeScreen:insert(btnMessageAdmi)
	btnMessageAdmi:addEventListener( 'tap', selectOptionHome )
	
	local labelMessageAdmi = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/3.5, y = h + intH/2, width = intH/3,
        text = "Mensaje a administracion",  font = fontDefault, fontSize = 32, align = "center",
	})
	labelMessageAdmi:setFillColor( 0 )
	homeScreen:insert(labelMessageAdmi)
	
	btnRecordVisits = display.newRect( intW/1.4, h + intH/2, intH/3, intH/3 )
	btnRecordVisits.option = 2
	btnRecordVisits:setFillColor( 1 )
	homeScreen:insert(btnRecordVisits)
	btnRecordVisits:addEventListener( 'tap', selectOptionHome )
	
	local labelRecordVisits = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/1.4, y = h + intH/2, width = intH/3,
        text = "Registro de visitas",  font = fontDefault, fontSize = 32, align = "center",
	})
	labelRecordVisits:setFillColor( 0 )
	homeScreen:insert(labelRecordVisits)
	
	--botones
	
	lastY = intH/1.2
	
	local btnCancelHome = display.newRect( intW/2 - 120, lastY, 200, 65 )
	btnCancelHome:setFillColor( 1, 0, 0 )
	homeScreen:insert(btnCancelHome)
	btnCancelHome:addEventListener( 'tap', returnLoginGuard)
	
	local labelCancelHome = display.newText( {   
        x = intW/2 - 120, y = lastY,
        text = "Cancelar",  font = fontDefault, fontSize = 28
	})
	labelCancelHome:setFillColor( 1 )
	homeScreen:insert(labelCancelHome)
	
	btnAceptOptionn = display.newRect( intW/2 + 120, lastY, 200, 65 )
	btnAceptOptionn:setFillColor( 0, 0, 1 )
	btnAceptOptionn.option = 0
	btnAceptOptionn.alpha = .3
	homeScreen:insert(btnAceptOptionn)
	--btnSignLogin:addEventListener( 'tap', doSignIn)
	
	local labelAceptOption = display.newText( {   
        x = intW/2 + 120, y = lastY,
        text = "Aceptar",  font = fontDefault, fontSize = 28
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