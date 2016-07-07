---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

local composer = require( "composer" )
local RestManager = require('src.resources.RestManager')

Panel = {}
function Panel:new()
    -- Variables
    local self = display.newGroup()
    local fxTap = audio.loadSound( "fx/click.wav")
    local intW = display.contentWidth
    local intH = display.contentHeight
    local midW = display.contentCenterX
    local midH = display.contentCenterY
    local h = display.topStatusBarContentHeight
    local notif =  {}
    
    -------------------------------------
    -- Creamos el top bar
    -- @param isWelcome boolean pantalla principal
    ------------------------------------ 
    function self:build()
        
        bg = display.newRect( intW - 75, h, 150, intH - h )
        bg.anchorY = 0
        bg:setFillColor( .5, .2 )
        self:insert(bg)
        
        reloadPanel()
    end
    
    function reloadPanel()
        clearNotif()
        RestManager.getNotif()
    end
    
    function clearNotif()
        for i=1, #notif do
            if notif[i] then
                notif[i]:removeSelf()
                notif[i] = nil
            end
        end
        notif =  {}
    end
    
    function updateAction(event)
        clearNotif()
        RestManager.updateVisitAction(event.target.idVisit, event.target.newAction)
    end
    
    function drawNotif(items)
        
        for z = 1, #items, 1 do 
            local idx = #notif + 1
            
            notif[idx] = display.newContainer( 150, 100 )
            notif[idx].x = intW - 75
            notif[idx].y = h + (z*100) - 52
            self:insert( notif[idx] )
            
            local btnNotif = display.newRect( 0, 0, 150, 98 )
            notif[idx]:insert(btnNotif)
            if items[z].action == "2" then
                btnNotif:setFillColor( 0, 102/255, 0 )
                btnNotif.strokeWidth = 8
                btnNotif:setStrokeColor( 0, 50/255, 0 )
                btnNotif.idVisit = items[z].id
                btnNotif.newAction = 4
                btnNotif:addEventListener( 'tap', updateAction )
            elseif items[z].action == "3" then
                btnNotif:setFillColor( 102/255, 0, 0 )
                btnNotif.strokeWidth = 8
                btnNotif:setStrokeColor( 50/255, 0, 0 )
                btnNotif.idVisit = items[z].id
                btnNotif.newAction = 5
                btnNotif:addEventListener( 'tap', updateAction )
            elseif items[z].action == "4" then
                btnNotif:setFillColor( 0, 102/255, 0, .2 )
                btnNotif.strokeWidth = 8
                btnNotif:setStrokeColor( 0, 50/255, 0, .2 )
            elseif items[z].action == "5" then
                btnNotif:setFillColor( 102/255, 0, 0, .2 )
                btnNotif.strokeWidth = 8
                btnNotif:setStrokeColor( 50/255, 0, 0, .2 )
            end 
            --[[
            local btnNumCondo = display.newRect( 0, 0, 150, 98 )
            btnNumCondo:setFillColor( 0, .5 )
            notif[idx]:insert(btnNumCondo)
            ]]
            
            local labelNumCondo = display.newText( {
                text = items[z].nombre,   
                x = 0, y = 0,
                font = fontDefaultBold, fontSize = 50, align = "center"
            })
            labelNumCondo:setFillColor( 1 )
            notif[idx]:insert(labelNumCondo)
        end
        
    end
    
    return self
end







