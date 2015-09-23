
local Globals = require('src.resources.Globals')

---------------------------------------------------------------------------------
-- new alert()
---------------------------------------------------------------------------------

local messageConfirmAdmin

function NewAlert(message, width, height)

	if not messageConfirmAdmin then
    
		local midW = display.contentWidth / 2
		local midH = display.contentHeight / 2
		messageConfirmAdmin = display.newGroup()
        
		local bgShade = display.newRect( midW, midH, display.contentWidth, display.contentHeight )
		bgShade:setFillColor( 0, 0, 0, .3 )
		messageConfirmAdmin:insert(bgShade)
		bgShade:addEventListener( 'tap', sinAction)
        
		local bg = display.newRoundedRect( midW, midH, width, height, 10 )
		bg:setFillColor( .3, .3, .3 )
		messageConfirmAdmin:insert(bg)
	
		local labelConfirmAdmin= display.newText( {   
			x = midW, y = midH,
			text = message,  font = fontDefault, fontSize = 32, align = "center",
		})
		labelConfirmAdmin:setFillColor( 1 )
		messageConfirmAdmin:insert(labelConfirmAdmin)
		
	else
	
		messageConfirmAdmin:removeSelf()
		messageConfirmAdmin = nil
		NewAlert(message, width, height)
		
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