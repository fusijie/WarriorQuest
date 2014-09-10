require "Cocos2d"
require "Cocos2dConstants"


local ChooseRoleScene  = class("ChooseRoleScene",function ()
	return cc.Scene:create()
end)

local layer --main layer
local sortorder = {1,2,3} --hero's tag
local pos = {{x=270,y=180},{x=400,y=120},{x=530,y=180}} --heroes' pos
local isMoving = false
local direction = 0

function ChooseRoleScene.create()
    local scene = ChooseRoleScene.new()
    layer = scene:createLayer()
    scene:addChild(layer)
    scene:initTouchDispatcher()
    return scene
end

function ChooseRoleScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

local function addHero(hero_type, pos)
    local Hero = require("Hero")
    local hero = Hero:create(hero_type)
    hero:setScale(8.0)
    hero:setRotation3D({0,0,0})
    hero:setPosition(pos)
    return hero
end

function ChooseRoleScene:createLayer()
    
    --create layer
    local layer = cc.Layer:create()
    
    --create bk
    local bk = cc.Sprite:create("cr_bk.jpg")
    bk:setAnchorPoint(0.5,0.5)
    bk:setPosition(self.origin.x + self.visibleSize.width/2, self.origin.y + self.visibleSize.height/2)
    layer:addChild(bk)
    
    --create bag
    local bag = cc.Sprite:create("res/cr_bag.png")
    bag:setAnchorPoint(1.0,0)
    bag:setScale(0.6)
    bag:setPosition(self.origin.x + self.visibleSize.width - 20,self.origin.y)
    layer:addChild(bag)
        
    --create warrior,archer,sorceress
    local warrior = addHero(0,{x=400,y=120})
    warrior:setTag(2)
    layer:addChild(warrior)
    
    --create warrior,archer,sorceress
    local archer = addHero(1,{x=270,y=180})
    archer:setTag(1)
    layer:addChild(archer)
    
    --create warrior,archer,sorceress
    local sorceress = addHero(2,{x=530,y=180})
    sorceress:setTag(3)
    layer:addChild(sorceress)
    
    --create arrow
    local function touchEvent_arrowleft(sender,eventType)
    	if eventType == ccui.TouchEventType.began then
    		direction = 1
    	elseif eventType == ccui.TouchEventType.ended then
    	    direction = 0
    	elseif eventType == ccui.TouchEventType.canceled then
    	    direction = 0
    	end
    end
    
    local function touchEvent_arrowright(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            direction = 2
        elseif eventType == ccui.TouchEventType.ended then
            direction = 0
        elseif eventType == ccui.TouchEventType.canceled then
            direction = 0
        end
    end
    
    local function touchEvent_arrowreset(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            layer:getChildByTag(sortorder[2]):setRotation3D({x=0,y=50,z=0})
        end
    end
    
    local picfileName = "cr_left.png"
    local button_left = ccui.Button:create()
    button_left:loadTextures(picfileName,picfileName,"")
    button_left:setPosition(300,50)
    button_left:addTouchEventListener(touchEvent_arrowleft)
    layer:addChild(button_left)
    
    picfileName = "cr_right.png"
    local button_right = ccui.Button:create()
    button_right:loadTextures(picfileName,picfileName,"")
    button_right:setPosition(500,50)
    button_right:addTouchEventListener(touchEvent_arrowright)
    layer:addChild(button_right)
    
    picfileName = "cr_reset.png"
    local button_reset = ccui.Button:create()
    button_reset:loadTextures(picfileName,picfileName,"")
    button_reset:setPosition(400,50)
    button_reset:addTouchEventListener(touchEvent_arrowreset)
    layer:addChild(button_reset)
    
    local function update(dt)
        if direction == 1  then --left
            local t = layer:getChildByTag(sortorder[2]):getRotation3D()
        	layer:getChildByTag(sortorder[2]):setRotation3D({x=0,y=t.y-5,z=0})
        elseif direction == 2 then --right
            local t = layer:getChildByTag(sortorder[2]):getRotation3D()
            layer:getChildByTag(sortorder[2]):setRotation3D({x=0,y=t.y+5,z=0})
        else
        
        end
    end
    
    cc.Director:getInstance():getScheduler():scheduleScriptFunc(update,0,false)
    
    --button
    local function touchEvent_return(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            print("return to main menu")
        end
    end  

    local return_Button = ccui.Button:create()
    return_Button:setTouchEnabled(true)
    return_Button:loadTextures("cr_btn_normal.png", "cr_btn_pressed.png", "")
    return_Button:setTitleText("Return")
    return_Button:setAnchorPoint(0,1)
    return_Button:setPosition(20,600)
    return_Button:addTouchEventListener(touchEvent_return)        
    layer:addChild(return_Button)
    
    local function touchEvent_next(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            print("go to game")
            local scene = require("BattleFieldScene")
            cc.Director:getInstance():replaceScene(scene.create())
        end
    end  

    local next_Button = ccui.Button:create()
    next_Button:setTouchEnabled(true)
    next_Button:loadTextures("cr_btn_normal.png", "cr_btn_pressed.png", "")
    next_Button:setTitleText("Next")
    next_Button:setAnchorPoint(0,1)
    next_Button:setPosition(680,600)
    next_Button:addTouchEventListener(touchEvent_next)        
    layer:addChild(next_Button)
    
    return layer
end


function ChooseRoleScene:initTouchDispatcher()
    local isavaliable = false
    local touchbeginPt
    local listenner = cc.EventListenerTouchOneByOne:create()
    listenner:setSwallowTouches(true)
    listenner:registerScriptHandler(function(touch, event)
        touchbeginPt = touch:getLocation()
        isavaliable = true
        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN )
    listenner:registerScriptHandler(function(touch, event)
        if isavaliable == true and isMoving == false then
            local dist = touch:getLocation().x - touchbeginPt.x
            if dist>50 then
                --right
                self:rotate3Heroes(true)
                isavaliable = false	
            elseif dist<-50 then
                --left
                self:rotate3Heroes(false)
                isavaliable = false
            else
        
            end
        end
    end,cc.Handler.EVENT_TOUCH_MOVED )
    listenner:registerScriptHandler(function(touch, event)
        isavaliable = false
        layer:getChildByTag(sortorder[2]):switchWeapon()
        layer:getChildByTag(sortorder[2]):switchArmour()
    end,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, layer)
end

function ChooseRoleScene:rotate3Heroes(isRight)
    local rotatetime = 0.3
    if isRight then
        local middle = layer:getChildByTag(sortorder[2])
        middle:runAction(cc.Sequence:create(
                cc.CallFunc:create(function() isMoving = true end), 
                cc.Spawn:create(
                    cc.MoveTo:create(rotatetime,pos[3]),
                    cc.ScaleTo:create(rotatetime,7)),
                cc.CallFunc:create(function() 
                    isMoving = false
                    for i=1,3 do
                        layer:getChildByTag(sortorder[i]):setRotation3D({x=0,y=50,z=0})
                    end
                    end)))
        local left = layer:getChildByTag(sortorder[1])
        left:runAction(cc.Spawn:create(cc.MoveTo:create(rotatetime,pos[2]),cc.ScaleTo:create(rotatetime,8)))
        local right = layer:getChildByTag(sortorder[3])
        right:runAction(cc.Spawn:create(cc.MoveTo:create(rotatetime,pos[1]),cc.ScaleTo:create(rotatetime,7)))
    	local t = sortorder[3]
    	sortorder[3]=sortorder[2]
    	sortorder[2]=sortorder[1]
    	sortorder[1]=t
    else
        local middle = layer:getChildByTag(sortorder[2])
        middle:runAction(cc.Sequence:create(
            cc.CallFunc:create(function() 
                isMoving = true
                for i=1,3 do
                    layer:getChildByTag(sortorder[i]):setRotation3D({x=0,y=50,z=0})
                end
            end), 
            cc.Spawn:create(
                cc.MoveTo:create(rotatetime,pos[1]),
                cc.ScaleTo:create(rotatetime,7)),
            cc.CallFunc:create(function() isMoving = false end)))
        local left = layer:getChildByTag(sortorder[1])
        left:runAction(cc.Spawn:create(cc.MoveTo:create(rotatetime,pos[3]),cc.ScaleTo:create(rotatetime,7)))
        local right = layer:getChildByTag(sortorder[3])
        right:runAction(cc.Spawn:create(cc.MoveTo:create(rotatetime,pos[2]),cc.ScaleTo:create(rotatetime,8)))
        local t = sortorder[1]
        sortorder[1]=sortorder[2]
        sortorder[2]=sortorder[3]
        sortorder[3]=t
    end
end

return ChooseRoleScene