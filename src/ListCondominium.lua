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
		labelNumCondo:setFillColor( 0, 110/255, 0 )
		containerListCondo[i]:insert(labelNumCondo)
	
        svListCondo:setScrollHeight(contY + 100)
		if i%numMax == 0 then
			contX = 0
			contY = contY + 170
		end		
		contX = contX + 1
		
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
	local midScreen = (intW/2)-75
	screen:insert(listCondominiumScreen)
	
    local bgLogin = display.newRect( intW/2, h, intW, intH )
    bgLogin.fill = { type="image", filename="img/btn/fillPattern.jpg" }
	bgLogin.anchorY = 0
	listCondominiumScreen:insert(bgLogin)
	
	local imgArrowBack = display.newImage( "img/btn/seleccionOpcion-regresarSuperior.png" )
	imgArrowBack.x = 30
	imgArrowBack.y = h + 40
	listCondominiumScreen:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnRecordVisit)
	
	local labelArrowBack = display.newText( {   
        x = 125, y = h + 40,
        text = "REGRESAR",  font = fontLatoBold, fontSize = 26
	})
	labelArrowBack:setFillColor( .2 )
	listCondominiumScreen:insert(labelArrowBack)
	labelArrowBack:addEventListener( 'tap', returnRecordVisit)
	
	local labelWelcomeListCondo = display.newText( {   
        x = midScreen, y = h + 100, 
        text = "Selecciona el condominio",  font = fontLatoRegular, fontSize = 36
	})
	labelWelcomeListCondo:setFillColor( .2 )
	listCondominiumScreen:insert(labelWelcomeListCondo)
	
	local bgSvListCondo = display.newRect( midScreen, h + intH/2 - 20, intW - 236, 446 )
	bgSvListCondo:setFillColor( 54/255, 80/255, 131/255 )
	listCondominiumScreen:insert(bgSvListCondo)
	
	--scroll
	svListCondo = widget.newScrollView
	{
		x = midScreen,
		y = h + intH/2 - 20,
		width = intW - 240,
		height = 440,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		isBounceEnabled = false,
		backgroundColor = { 6/255, 58/255, 98/255 }
	}
	listCondominiumScreen:insert(svListCondo)
	--svListCondo:addEventListener( 'tap', noAction)
	
	getNumCondo()
	
	local paint = {
		type = "gradient",
		color1 = { 49/255, 187/255, 40/255 },
		color2 = { 45/255, 161/255, 45/255, 0.9 },
		direction = "down"
	}
	
	local btnContinue = display.newRoundedRect( midScreen, intH - 70, 200, 70, 10 )
	btnContinue:setFillColor( 51/255, 176/255, 46/255 )
	btnContinue.fill = paint
	listCondominiumScreen:insert(btnContinue)
	btnContinue:addEventListener( 'tap', getNumCondominium )
	
	local labelChangeCodo = display.newText( {   
        x = midScreen, y = intH - 75,
        text = "CONTINUAR",  font = fontLatoRegular, fontSize = 28
	})
	labelChangeCodo:setFillColor( 1 )
	listCondominiumScreen:insert(labelChangeCodo)
   
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