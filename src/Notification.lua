-----------------------------------------------------------------------------------------
-- Booking
-- Alfredo chi
-- Envio de mensaje
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
local notificationScreen = display.newGroup()

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

fontDefault = native.systemFont

----elementos

local labelMsgConfirmation
local labelMsgNameVisit
local labelMsgReasonVisit
local labelMsgDateVisit
	
local btnMsgContinue

local lastId

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
	
--regresa al menu de home
function returnHomeMsg( event )
	composer.removeScene("src.LoginGuard")
	composer.gotoScene("src.LoginGuard")
end

-- Genera la fecha en formato
function getDateNoti(strDate)
    local fecha
    for k, v, u, m, s  in string.gmatch(strDate, "(%w+)-(%w+)-(%w+) (%w+):(%w+)") do
		local timeSystem
		if tonumber(m) < 13 then
			timeSystem = ' A.M'
		else
			timeSystem = ' P:M'
		end
        fecha = u .. " de "..Globals.Months[tonumber(v)].." de " .. k .. " " .. m ..":" .. s .. timeSystem
		
    end
    return fecha
end

---------------------------------------------------
--------------Funciones defaults-------------------
---------------------------------------------------

-- "scene:create()"
function scene:create( event )

	lastId = event.params.lastId
	local infoRecordVisit = DBManager.getRecordVisitById(lastId)
    
	local screen = self.view
	screen:insert(notificationScreen)
	
    local midScreen = (intW/2)-75
    local bgLogin = display.newRect( intW/2, h, intW, intH )
    bgLogin.fill = { type="image", filename="img/btn/fillPattern.jpg" }
	bgLogin.anchorY = 0
	notificationScreen:insert(bgLogin)
	
	local lastY = 100 + h
	
	labelMsgConfirmation = display.newText( {   
        x = midScreen, y = lastY,
        text = "La visita ha sido registrada",  font = fontLatoRegular, fontSize = 38
	})
	labelMsgConfirmation:setFillColor( .2 )
	notificationScreen:insert(labelMsgConfirmation)
	
	lastY = lastY + 60
	
	local labelMsgNotiConfirm = display.newText( {   
        x = midScreen, y = lastY,
        text = "Se ha notificado al condóminio mediante mensaje a su aplicación",  font = fontLatoLight, fontSize = 30
	})
	labelMsgNotiConfirm:setFillColor( .2 )
	notificationScreen:insert(labelMsgNotiConfirm)
	
	lastY = lastY + 40
	
	local bgNotiMSG = display.newRoundedRect( midScreen, lastY, 800, 430, 10 )
	bgNotiMSG.anchorY = 0
	bgNotiMSG:setFillColor( 6/255, 58/255, 98/255 )
	bgNotiMSG.strokeWidth = 4
	bgNotiMSG:setStrokeColor( 54/255, 80/255, 131/255 )
	notificationScreen:insert(bgNotiMSG)

	lastY = lastY + 30
	
	local bgInfoNotiMSG = display.newRoundedRect( midScreen, lastY, 740, 300, 10 )
	bgInfoNotiMSG.anchorY = 0
	bgInfoNotiMSG:setFillColor( 1 )
	notificationScreen:insert(bgInfoNotiMSG)
	
	
	labelMsgDate = display.newText( {   
        x = midScreen, y = lastY + 30,
		width = 690,
        text = "09 de septiembre del 2015 05:57 pm",  font = fontLatoRegular, fontSize = 22, align = "right",
	})
	labelMsgDate:setFillColor( 78/255, 78/255, 78/255 )
	notificationScreen:insert(labelMsgDate)
	
	labelTiTleNameVisit = display.newText( {   
        x = midScreen, y = lastY + 75,
		width = 700,
        text = "VISITANTE: ",  font = fontLatoBold, fontSize = 24
	})
	labelTiTleNameVisit:setFillColor( 78/255, 78/255, 78/255 )
	notificationScreen:insert(labelTiTleNameVisit)
	
	labelMsgNameVisit = display.newText( {   
        x = midScreen + 75, y = lastY + 73,
		width = 550,
        text = infoRecordVisit.nombreVisitante,  font = fontLatoRegular, fontSize = 26
	})
	labelMsgNameVisit:setFillColor( 78/255, 78/255, 78/255 )
	notificationScreen:insert(labelMsgNameVisit)
	labelMsgNameVisit.y = labelMsgNameVisit.y + labelMsgNameVisit.contentHeight/2 - 13
	
	labelTitleReasonVisit = display.newText( {   
        x = midScreen, y = lastY + 125,
		width = 700,
        text = "MOTIVO : ",  font = fontLatoBold, fontSize = 24
	})
	labelTitleReasonVisit:setFillColor( 78/255, 78/255, 78/255 )
	notificationScreen:insert(labelTitleReasonVisit)
	
	labelMsgReasonVisit = display.newText( {   
        x = midScreen + 75, y = lastY + 123,
		width = 550,
        text = infoRecordVisit.motivo,  font = fontLatoRegular, fontSize = 24
	})
	labelMsgReasonVisit:setFillColor( 78/255, 78/255, 78/255 )
	notificationScreen:insert(labelMsgReasonVisit)
	
	labelMsgReasonVisit.y = labelMsgReasonVisit.y + labelMsgReasonVisit.contentHeight/2 - 13
	
	lastY = lastY + 348
	
	local paint = {
		type = "gradient",
		color1 = { 49/255, 187/255, 40/255 },
		color2 = { 45/255, 161/255, 45/255, 0.9 },
		direction = "down"
	}
	
	btnMsgContinue = display.newRoundedRect( midScreen, lastY, 200, 70, 10 )
	btnMsgContinue:setFillColor( 205/255, 69/255, 69/255 )
	notificationScreen:insert(btnMsgContinue)
	btnMsgContinue.fill = paint
	btnMsgContinue:addEventListener( 'tap', returnHomeMsg )
	
	local labelMsgContinue = display.newText( {   
        x = midScreen, y = lastY,
        text = "ACEPTAR",  font = fontLatoRegular, fontSize = 28
	})
	labelMsgContinue:setFillColor( 1 )
	notificationScreen:insert(labelMsgContinue)
	
	local dateNoti = getDateNoti(infoRecordVisit.fechaHora)
	labelMsgDate.text = dateNoti
    
   reloadPanel()
end

-- "scene:show()"
function scene:show( event )
end

-- "scene:hide()"
function scene:hide( event )
	--local phase = event.phase
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