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
local listSubjectScr = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont

----elementos

local svListSubject

local conListSubject = {}

local idxSubject = 1

local numSubject = 0
local idSubject = 0

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
function getnumSubjectminium( event )
	
	Globals.numSubjectminium = numSubject
	Globals.idSubjectminium = idSubject
	composer.gotoScene("src.RecordVisit")

	return true
	
end

--selecionamos el condominio
function selectCondo( event )

	conListSubject[idxSubject].alpha = 1
	idxSubject = event.target.posc
	event.target.alpha = .7
	numSubject = event.target.num
	idSubject = event.target.id

end

--pinta los condominios
function getnumSubject()

    local listSubject = DBManager.getAsuntos()

	local contX = 1
	local contY = 100
	local numMax = svListSubject.contentWidth / 260
	local mult = 10^(idp or 0)
	numMax = math.round(numMax * mult + 0.5)
	numMax = numMax - 2
    
    local midScreen = (intW/2) - 110
	local posX = {midScreen - 170, midScreen + 170}
    if numMax == 3 then
        posX = {midScreen - 320, midScreen, midScreen + 320}
    end
    
	for i = 1, #listSubject, 1 do
		
		conListSubject[i] = display.newContainer( 260, 100 )
        conListSubject[i].x = posX[contX]
        conListSubject[i].y = contY
		conListSubject[i].num = listSubject[i].name
		conListSubject[i].id = listSubject[i].id
		conListSubject[i].posc = i
        svListSubject:insert( conListSubject[i] )
		conListSubject[i]:addEventListener( 'tap', selectCondo )
		
		local btnnumSubject = display.newRoundedRect( 0, 0, 260, 100, 10 )
		btnnumSubject:setFillColor( 1 )
		conListSubject[i]:insert(btnnumSubject)
		
		local imgnumSubject = display.newImage( "img/btn/iconSubject.png" )
		imgnumSubject.x = 100
		imgnumSubject.y = -30
		imgnumSubject.alpha = .5
		conListSubject[i]:insert(imgnumSubject)
		
		local labelnumSubject = display.newText( {
            text = listSubject[i].name,   
            x = 0, y = 0, width = 250,
            font = fontLatoBold, fontSize = 30, align = "center"
		})
		labelnumSubject:setFillColor( 0, 110/255, 0 )
		conListSubject[i]:insert(labelnumSubject)
	
        svListSubject:setScrollHeight(contY + 100)
		if i%numMax == 0 then
			contX = 0
			contY = contY + 140
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
	screen:insert(listSubjectScr)
    local midScreen = (intW/2)-75
	
	local bgLogin = display.newRect( intW/2, h, intW, intH )
    bgLogin.fill = { type="image", filename="img/btn/fillPattern.jpg" }
	bgLogin.anchorY = 0
	listSubjectScr:insert(bgLogin)
	
	local imgArrowBack = display.newImage( "img/btn/seleccionOpcion-regresarSuperior.png" )
	imgArrowBack.x = 30
	imgArrowBack.y = h + 40
	listSubjectScr:insert(imgArrowBack)
	imgArrowBack:addEventListener( 'tap', returnRecordVisit)
	
	local labelArrowBack = display.newText( {   
        x = 125, y = h + 40,
        text = "REGRESAR",  font = fontLatoBold, fontSize = 26
	})
	labelArrowBack:setFillColor( .2 )
	listSubjectScr:insert(labelArrowBack)
	labelArrowBack:addEventListener( 'tap', returnRecordVisit)
	
	local labelWelcomelistSubject = display.newText( {   
        x = midScreen, y = h + 100, 
        text = "Selecciona el asunto",  font = fontLatoRegular, fontSize = 36
	})
	labelWelcomelistSubject:setFillColor( .2 )
	listSubjectScr:insert(labelWelcomelistSubject)
	
	local bgsvListSubject = display.newRect( midScreen, h + intH/2 - 20, intW - 236, 446 )
	bgsvListSubject:setFillColor( 54/255, 80/255, 131/255 )
	listSubjectScr:insert(bgsvListSubject)
	
	--scroll
	svListSubject = widget.newScrollView
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
	listSubjectScr:insert(svListSubject)
	--svListSubject:addEventListener( 'tap', noAction)
	
	getnumSubject()
	
	local paint = {
		type = "gradient",
		color1 = { 49/255, 187/255, 40/255 },
		color2 = { 45/255, 161/255, 45/255, 0.9 },
		direction = "down"
	}
	
	local btnContinue = display.newRoundedRect( midScreen, intH - 70, 200, 70, 10 )
	btnContinue:setFillColor( 51/255, 176/255, 46/255 )
	btnContinue.fill = paint
	listSubjectScr:insert(btnContinue)
	btnContinue:addEventListener( 'tap', getnumSubjectminium )
	
	local labelChangeCodo = display.newText( {   
        x = midScreen, y = intH - 75,
        text = "CONTINUAR",  font = fontLatoRegular, fontSize = 28
	})
	labelChangeCodo:setFillColor( 1 )
	listSubjectScr:insert(labelChangeCodo)
   
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