-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
local widget = require( "widget" )
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
local scene = composer.newScene()

--variables
local homeScreen = display.newGroup()

local settingsGuard = DBManager.getGuardActive()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont

----elementos
local btnAceptOptionn
local btnMessageAdmi
local btnRecordVisits

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
		composer.removeScene("src.ListCondominium")
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
	
	local bgLogin = display.newRect( intW/2, h, intW, intH )
    bgLogin.fill = { type="image", filename="img/btn/fillPattern.jpg" }
	bgLogin.anchorY = 0
	homeScreen:insert(bgLogin)
	
	local imgArrowBack = display.newImage( "img/btn/seleccionOpcion-regresarSuperior.png" )
	imgArrowBack.x = 30
	imgArrowBack.y = h + 40
	homeScreen:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnLoginGuard)
	
	local labelArrowBack = display.newText( {   
        x = 125, y = h + 40,
        text = "REGRESAR",  font = fontLatoBold, fontSize = 26
	})
	labelArrowBack:setFillColor( .2 )
	homeScreen:insert(labelArrowBack)
	labelArrowBack:addEventListener( 'tap', returnLoginGuard)
	
	local labelWeolcomeGuard= display.newText( {   
        x = (intW/2) - 25, y = h + 40,
        text = "Bienvenido " .. settingsGuard.nombre,  font = fontLatoBold, fontSize = 40
	})
	labelWeolcomeGuard:setFillColor( .2 )
	homeScreen:insert(labelWeolcomeGuard)
	
	lastY = h + 150
	
	local msgInfoHome = "Selecciona lo que deseas registrar. \nPuedes regresar a la pantalla anterior seleccionando la opción 'REGRESAR'."
	
	local labelInfoHome = display.newText( {   
        x = (intW/2) - 50, y = lastY, width = intW - 225,
        text = msgInfoHome,  font = fontLatoRegular, fontSize = 26
	})
	labelInfoHome:setFillColor( .2 )
	homeScreen:insert(labelInfoHome)
	labelInfoHome.y = labelInfoHome.y + labelInfoHome.contentHeight/2
	
	
	local bgOpcionMsg = display.newRoundedRect( (intW/2)-75, h + 300, 800, 300, 10 )
	bgOpcionMsg.anchorY = 0
	bgOpcionMsg:setFillColor( 1, 1, 1, 0 )
	bgOpcionMsg.strokeWidth = 5
	bgOpcionMsg:setStrokeColor( 15/255, 68/255, 108/255 )
	homeScreen:insert(bgOpcionMsg)
	
	btnMessageAdmi = display.newRoundedRect( intW/2 - 225, h + 450, 200, 200, 12 )
	btnMessageAdmi.option = 1
	btnMessageAdmi:setFillColor( 15/255, 68/255, 108/255 )
	btnMessageAdmi.strokeWidth = 4
	btnMessageAdmi:setStrokeColor( 54/255, 80/255, 131/255 )
	homeScreen:insert(btnMessageAdmi)
	--btnMessageAdmi:addEventListener( 'tap', selectOptionHome )
	btnMessageAdmi:addEventListener( 'tap', aceptOptionHome)
	
	local imgMessageAdmi = display.newImage( "img/btn/envioMensaje.png" )
	imgMessageAdmi.x =	intW/2 - 225
	imgMessageAdmi.y =  h + 420
	homeScreen:insert(imgMessageAdmi)
	
	local labelMessageAdmi = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/2 - 225, y = h + 510, width = 200,
        text = "Mensaje a Administración",  font = fontLatoRegular, fontSize = 22, align = "center",
	})
	labelMessageAdmi:setFillColor( 1 )
	homeScreen:insert(labelMessageAdmi)
	
	btnRecordVisits = display.newRoundedRect( intW/2 + 75, h + 450, 200, 200, 12 )
	btnRecordVisits.option = 2
	btnRecordVisits:setFillColor( 15/255, 68/255, 108/255 )
	btnRecordVisits.strokeWidth = 4
	btnRecordVisits:setStrokeColor( 54/255, 80/255, 131/255 )
	homeScreen:insert(btnRecordVisits)
	--btnRecordVisits:addEventListener( 'tap', selectOptionHome )
	btnRecordVisits:addEventListener( 'tap', aceptOptionHome)
	
	local imgMessageAdmi = display.newImage( "img/btn/RegistroVisita.png" )
	imgMessageAdmi.x =	intW/2 + 75
	imgMessageAdmi.y =  h + 420
	homeScreen:insert(imgMessageAdmi)
	
	local labelRecordVisits = display.newText( {   
        --x = intW/3, y = lastY,
		x = intW/2 + 75, y = h + 510, width = 200,
        text = "REGISTRO DE VISITAS",  font = fontLatoRegular, fontSize = 22, align = "center",
	})
	labelRecordVisits:setFillColor( 1 )
	homeScreen:insert(labelRecordVisits)
   
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