-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Login
-- Geek Bucket
-----------------------------------------------------------------------------------------

--componentes 
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
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
local idCondo = 0

---------------------------------------------------
------------------ Funciones ----------------------
---------------------------------------------------

--asignamos el numero al condominio
function getNumCondominium( event )
	
	Globals.numCondominium = NumCondo
	Globals.idCondominium = idCondo
	
	composer.gotoScene("src.RecordVisit")

	return true
	
end

--selecionamos el condominio
function selectCondo( event )

	containerListCondo[lasPoscCondo].alpha = 1
	lasPoscCondo = event.target.posc
	event.target.alpha = .7
	NumCondo = event.target.num
	idCondo = event.target.id

end

--pinta los condominios
function getNumCondo()

	local listCondo = DBManager.getCondominiums()

	local contX = 1
	local contY = 100
	local numMax = svListCondo.contentWidth / 150
	local mult = 10^(idp or 0)
	numMax = math.round(numMax * mult + 0.5)
	numMax = numMax - 2
	
	for i = 1, #listCondo, 1 do
		
		containerListCondo[i] = display.newContainer( 130, 130 )
        containerListCondo[i].x = (contX * 170) - 40
        containerListCondo[i].y = contY
		containerListCondo[i].num = listCondo[i].nombre
		containerListCondo[i].id = listCondo[i].id
		containerListCondo[i].posc = i
        svListCondo:insert( containerListCondo[i] )
		containerListCondo[i]:addEventListener( 'tap', selectCondo )
		
		local btnNumCondo = display.newRoundedRect( 0, 0, 130, 130, 10 )
		btnNumCondo:setFillColor( 1 )
		containerListCondo[i]:insert(btnNumCondo)
		
		local imgNumCondo = display.newImage( "img/btn/CONDOMINIO.png" )
		imgNumCondo.x =	0
		imgNumCondo.y = 0
		imgNumCondo.width = 80
		imgNumCondo.height = 80
		imgNumCondo.alpha = .5
		containerListCondo[i]:insert(imgNumCondo)
		
		local labelNumCondo = display.newText( {
            text = listCondo[i].nombre,   
            x = 0, y = 0,
            font = fontDefault, fontSize = 60, align = "center"
		})
		labelNumCondo:setFillColor( 205/255, 69/255, 69/255 )
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
	bgLogin:setFillColor( 54/255, 80/255, 131/255 )
	listCondominiumScreen:insert(bgLogin)
	
	local bgfringeUp = display.newRect( 0, h, intW, 80 )
	bgfringeUp.anchorX = 0
	bgfringeUp.anchorY = 0
	bgfringeUp:setFillColor( 222/255, 222/255, 222/255 )
	listCondominiumScreen:insert(bgfringeUp)
	
	local imgArrowBack = display.newImage( "img/btn/REGRESAR.png" )
	imgArrowBack.x = intW - 185
	imgArrowBack.y = h + 40
	listCondominiumScreen:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnRecordVisit )
	
	local labelArrowBack = display.newText( {   
        x = intW - 100, y = h + 40,
        text = "REGRESAR",  font = fontDefault, fontSize = 18
	})
	labelArrowBack:setFillColor( 64/255, 90/255, 139/255 )
	listCondominiumScreen:insert(labelArrowBack)
	
	local labelSelectCondo= display.newText( {   
        x = intW/2, y = h + 40,
        text = "SELECCIONA EL CONDOMINIO",  font = fontDefault, fontSize = 28
	})
	labelSelectCondo:setFillColor( 0 )
	listCondominiumScreen:insert(labelSelectCondo)
	
	local btnContinue = display.newRoundedRect( intW/2, intH - 70, 200, 70, 10 )
	btnContinue:setFillColor( 205/255, 69/255, 69/255 )
	listCondominiumScreen:insert(btnContinue)
	btnContinue:addEventListener( 'tap', getNumCondominium )
	
	local labelChangeCodo = display.newText( {   
        x = intW/2, y = intH - 70,
        text = "CONTINUAR",  font = fontDefault, fontSize = 28
	})
	labelChangeCodo:setFillColor( 1 )
	listCondominiumScreen:insert(labelChangeCodo)
	
	--scroll
	svListCondo = widget.newScrollView
	{
		x = intW/2,
		y = h + intH/2 - 40,
		width = intW - intW/4,
		height = 480,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		isBounceEnabled = false,
		backgroundColor = { 54/255, 80/255, 131/255 }
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