
local Globals = require('src.resources.Globals')

---------------------------------------------------------------------------------
-- new alert()
---------------------------------------------------------------------------------

local messageConfirmAdmin

function NewAlert( title ,message, typeAL)

	if not messageConfirmAdmin then
    
		local midW = display.contentWidth / 2
		local midH = display.contentHeight / 2
		local intW = display.contentWidth
		local intH = display.contentHeight
		messageConfirmAdmin = display.newGroup()
        
		local bgShade = display.newRect( midW, midH, display.contentWidth, display.contentHeight )
		bgShade:setFillColor( 0, 0, 0, .3 )
		messageConfirmAdmin:insert(bgShade)
		bgShade:addEventListener( 'tap', sinAction)
        
		local bg = display.newRoundedRect( midW, midH, 600, 400, 10 )
		bg:setFillColor( 6/255, 24/255, 46/255, .8)
		messageConfirmAdmin:insert(bg)
		
		local lineRecordVisit = display.newLine( intW/2 - 275, 380, intW/2 + 275, 380 )
		lineRecordVisit:setStrokeColor( 225/255, 0, 4/255 )
		lineRecordVisit.strokeWidth = 4
		lineRecordVisit.y = lineRecordVisit.y - bg.contentHeight/4
		messageConfirmAdmin:insert(lineRecordVisit)
		
		local labelTitleNewAlert = display.newText( {   
			x = midW, y = midH,
			text = title,  font = fontDefault, fontSize = 32, align = "center",
		})
		labelTitleNewAlert:setFillColor( 1 )
		labelTitleNewAlert.y = labelTitleNewAlert.y - bg.contentHeight/2 + 50
		messageConfirmAdmin:insert(labelTitleNewAlert)
	
		local labelMessageNewAlert = display.newText( {   
			x = midW, y = midH - 65,
			width = 550,
			text = message,  font = fontDefault, fontSize = 24, align = "center",
		})
		labelMessageNewAlert:setFillColor( 1 )
		labelMessageNewAlert.y = labelMessageNewAlert.y + labelMessageNewAlert.contentHeight/2
		messageConfirmAdmin:insert(labelMessageNewAlert)
		
		if typeAL == 1 then
			
			local btnCloseNewAlert = display.newRoundedRect( midW, midH + 150, 200, 60, 10 )
			btnCloseNewAlert:setFillColor( 51/255, 176/255, 46/255)
			messageConfirmAdmin:insert(btnCloseNewAlert)
			btnCloseNewAlert:addEventListener( 'tap', deleteNewAlert)
			
			local labelMessageNewAlert = display.newText( {   
				x = midW, y = midH + 135,
				text = "ACEPTAR",  font = fontDefault, fontSize = 26, align = "center",
			})
			labelMessageNewAlert:setFillColor( 1 )
			labelMessageNewAlert.y = labelMessageNewAlert.y + labelMessageNewAlert.contentHeight/2
			messageConfirmAdmin:insert(labelMessageNewAlert)
			
		end
		
	else
	
		messageConfirmAdmin:removeSelf()
		messageConfirmAdmin = nil
		NewAlert(title, message, typeAL)
		
	end
	
end

function deleteNewAlert()
	if messageConfirmAdmin then
		messageConfirmAdmin:removeSelf()
		messageConfirmAdmin = nil
	end
end

function sinAction( event )
	return true
end