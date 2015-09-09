-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
local composer = require( "composer" )
local widget = require( "widget" )
local Globals = require('src.resources.Globals')
local scene = composer.newScene()

--variables
local listCondominiumScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont

----elementos

local svListCondo

local containerListCondo = {}

local lasPoscCondo = 1

local NumCondo = 0

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

--asignamos el numero al condominio
function getNumCondominium( event )
	
	Globals.numCondominium = NumCondo
	
	composer.gotoScene("src.RecordVisit")

	return true
	
end

--selecionamos el condominio
function selectCondo( event )

	containerListCondo[lasPoscCondo].alpha = 1
	lasPoscCondo = event.target.posc
	event.target.alpha = .7
	NumCondo = event.target.num

end

--pinta los condominios
function getNumCondo()

	local contX = 1
	local contY = 100
	local numMax = svListCondo.contentWidth / 150
	local mult = 10^(idp or 0)
	numMax = math.round(numMax * mult + 0.5)
	numMax = numMax - 2
	
	for i = 1, 15, 1 do
		
		containerListCondo[i] = display.newContainer( 130, 130 )
        containerListCondo[i].x = (contX * 170) - 40
        containerListCondo[i].y = contY
		containerListCondo[i].num = "00" .. i
		containerListCondo[i].posc = i
        svListCondo:insert( containerListCondo[i] )
		containerListCondo[i]:addEventListener( 'tap', selectCondo )
		
		local btnNumCondo = display.newRect( 0, 0, 130, 130 )
		btnNumCondo:setFillColor( 1 )
		containerListCondo[i]:insert(btnNumCondo)
		
		local labelNumCondo = display.newText( {
            text = "00" .. i,     
            x = 0, y = 0,
            font = fontDefault, fontSize = 24, align = "center"
		})
		labelNumCondo:setFillColor( 0 )
		containerListCondo[i]:insert(labelNumCondo)
	
		if i%numMax == 0 then
			contX = 0
			contY = contY + 170
		end		
		contX = contX + 1
		
		svListCondo:setScrollHeight(contY + 150)
		
	end
	
end
	
--regresa a la pantalla de recordVisit
function returnRecordVisit( event )
	
	composer.gotoScene("src.RecordVisit")

	return true
	
end	


---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local screen = self.view
	
	screen:insert(listCondominiumScreen)
	
	local bgLogin = display.newRect( 0, h, intW, intH )
	bgLogin.anchorX = 0
	bgLogin.anchorY = 0
	bgLogin:setFillColor( 214/255, 226/255, 225/255 )
	listCondominiumScreen:insert(bgLogin)
	
	--[[local imgLogo = display.newRect( intW/2, h + 100, 150, 150 )
	imgLogo:setFillColor( 0 )
	listCondominiumScreen:insert(imgLogo)]]
	
	local imgArrowBack = display.newImage( "img/btn/REGRESAR.png" )
	imgArrowBack.x = 50
	imgArrowBack.height = 60
	imgArrowBack.width = 90
	imgArrowBack.y = h + imgArrowBack.contentHeight/2
	listCondominiumScreen:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnRecordVisit )
	
	local labelSelectCondo= display.newText( {   
        x = intW/2 - 200, y = h + 100,
        text = "Selecciona el condominio:",  font = fontDefault, fontSize = 28
	})
	labelSelectCondo:setFillColor( 0 )
	listCondominiumScreen:insert(labelSelectCondo)
	
	local btnContinue = display.newRect( intW/2 + 200, h + 100, 300, 65 )
	btnContinue:setFillColor( .2 )
	listCondominiumScreen:insert(btnContinue)
	btnContinue:addEventListener( 'tap', getNumCondominium )
	
	local labelChangeCodo = display.newText( {   
        x = intW/2 + 200, y = h + 100,
        text = "Continuar",  font = fontDefault, fontSize = 28
	})
	labelChangeCodo:setFillColor( 1 )
	listCondominiumScreen:insert(labelChangeCodo)
	
	--scroll
	svListCondo = widget.newScrollView
	{
		x = intW/2,
		y = h + intH/2 + 50,
		width = intW - intW/4,
		height = intH - 300 + h,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		isBounceEnabled = true,
		backgroundColor = { .85 }
	}
	listCondominiumScreen:insert(svListCondo)
	--svListCondo:addEventListener( 'tap', noAction)
	
	getNumCondo()
   
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