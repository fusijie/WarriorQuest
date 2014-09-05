require "Cocos2d"
require "extern"

--declare a class extends scene
local MainMenuScene = class("MainMenuScene",function()
    return cc.Scene:create()
end
)

function MainMenuScene.create()
    local scene = MainMenuScene.new()
    local layer = scene:createLayer();
    scene:addChild(layer)
    
    return scene
end

--constructor init member variable
function MainMenuScene:ctor()
    self.size = cc.Director:getInstance():getVisibleSize()
end

--crate a main layer
function MainMenuScene:createLayer()
    local mainLayer = cc.Layer:create()
    
    --create parallax node
    local parallax = cc.ParallaxNode:create()
    
    --set parallax child rate and point
    local childRate = {0.6,0.8,1.4,1.7}
    local childPoint = {{x=0,y=self.size.height*0.55},
        {x=0,y=self.size.height*0.77},
        {x=0,y=0},
        {x=self.size.width*3/4,y=self.size.height*0.4}}
        
    -- crate background add to parallax
    for i=1, 4 do
        local bgname = "xiaota/bg"..i..".png"
        --create local sprite bg1
        local bg1 = cc.Sprite:create(bgname)
        bg1:setAnchorPoint({x=0,y=0})
        bg1:setPosition(childPoint[i])
        bg1:setTag(1)
        --create bg2
        local bg2 = cc.Sprite:create(bgname)
        bg2:setAnchorPoint({x=0,y=0})
        bg2:setPosition({x=childPoint[i].x+bg1:getContentSize().width,y=childPoint[i].y})
        bg2:setTag(2)
        --add bg1 and bg2 to node
        local node = cc.Node:create()
        node:addChild(bg1)
        node:addChild(bg2)
        node:setTag(i)
        --add to parallax node
        parallax:addChild(node,i,{x=childRate[i],y=0},{0,0})
    end
    
    
    -- add parallax node to mainlayer
    mainLayer:addChild(parallax)
    
    --reset parallax child's point
    local function resetPoint()
        for i=1,4 do
            local node = parallax:getChildByTag(i)
            local bg1 = node:getChildByTag(1)
            local bg2 = node:getChildByTag(2)
            --first convert point relative to mainLayer
            local point1 = node:convertToWorldSpace({x=bg1:getPositionX(),y=bg1:getPositionY()})
            point1 = mainLayer:convertToNodeSpace(point1)
            if point1.x<-bg1:getContentSize().width then
                bg1:setPositionX(bg2:getPositionX()+bg2:getContentSize().width)
            end

            local point2 = node:convertToWorldSpace({x=bg2:getPositionX(),y=bg2:getPositionY()})
            point2 = mainLayer:convertToNodeSpace(point2)
            if point2.x<-bg2:getContentSize().width then
                bg2:setPositionX(bg1:getPositionX()+bg1:getContentSize().width)
            end
            
        end
    end
    
    --backgound move
    local function bgMove()
        
        --parallax always on the move
        local offset = -3
        local x = parallax:getPositionX()+offset
        parallax:setPositionX(x)

        resetPoint()
    end
    
    --background move
    local scheduleBgMoveID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(bgMove,0,false)
    
    --tanker
    local tanker = cc.Sprite3D:create("Sprite3DTest/girl.c3b")
    tanker:setPosition(self.size.width/2,self.size.height)
    tanker:setScale(2.0)
    
    --archer
    local archer = cc.Sprite3D:create("Sprite3DTest/girl.c3b")
    archer:setPosition(self.size.width*0.3,self.size.height)
    archer:setScale(2.0)
    
    --master
    local master = cc.Sprite3D:create("Sprite3DTest/girl.c3b")
    master:setPosition(self.size.width*0.7,self.size.height)
    master:setScale(2.0)
    
    --tanker animation
    local tankerAnimation = cc.Animation3D:create("Sprite3DTest/girl.c3b")
    local tankerAnimate = cc.Animate3D:create(tankerAnimation)
    tankerAnimate:retain()
    --archer animation
    local archerAnimation = cc.Animation3D:create("Sprite3DTest/girl.c3b")
    local archerAnimate = cc.Animate3D:create(archerAnimation)
    archerAnimate:retain()
    --master animation
    local masterAnimation = cc.Animation3D:create("Sprite3DTest/girl.c3b")
    local masterAnimate = cc.Animate3D:create(masterAnimation)
    masterAnimate:retain()
    
    --action
    local moveBy = cc.MoveBy:create(0.7,{x=0,y=-self.size.height*0.7})
    local jumpBy = cc.JumpBy:create(0.7,{x=0,y=0},self.size.height*0.4,1)
    --call back
    local function actionCallBack(sender,sprite)
    local rate = 1
    local schedulerID
        local function rotate()
            sprite.role:setRotation3D({x=0,y=rate,z=0})
            rate = rate+3
            if rate > 90 then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
                sender:runAction(cc.RepeatForever:create(sprite.animate))
            end
        end
    schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(rotate,0.001,false)
    end
    
    local tankerSequence = cc.Sequence:create(moveBy,jumpBy,cc.CallFunc:create(actionCallBack,{role=tanker,animate=tankerAnimate}))
    local archerSequence = cc.Sequence:create(moveBy:clone(),jumpBy:clone(),cc.CallFunc:create(actionCallBack,{role=archer,animate=archerAnimate}))
    local masterSequence = cc.Sequence:create(moveBy:clone(),jumpBy:clone(),cc.CallFunc:create(actionCallBack,{role=master,animate=masterAnimate}))
    
    --run  sprite action 
    tanker:runAction(tankerSequence)
    archer:runAction(archerSequence)
    master:runAction(masterSequence)

    --add sprite to mainLayer
    mainLayer:addChild(archer)
    mainLayer:addChild(master)
    mainLayer:addChild(tanker)
    
    --logo
    
    
    --menu
    local function menuCallBack(sender)
    
        local function menuClick()
            local scene = require("ChooseRoleScene")
            local activateGameScene = scene.create()
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleBgMoveID)
            cc.Director:getInstance():replaceScene(activateGameScene)
        end
        --menuitem run action
--        local menuAction = cc.Sequence:create(cc.ScaleTo:create(1,1.2),cc.ScaleTo:create(0.1,0.8),cc.ScaleTo:create(0.1,1),
--            cc.CallFunc:create(menuClick))
--        sender:runAction(menuAction)
        menuClick()
    end
    
    local start = cc.MenuItemImage:create("xiaota/begin_normal.png","xiaota/begin_selected.png")
    start:registerScriptTapHandler(menuCallBack)
    local menu = cc.Menu:create(start)
    menu:setPosition(-self.size.width*0.3,self.size.height*0.9)
--    menu:setVisible(false)
    menu:runAction(cc.Sequence:create(cc.DelayTime:create(2.0),cc.MoveBy:create(1.0,{x=self.size.width*0.8,y=0})))
    
    mainLayer:addChild(menu)
    
    
    return mainLayer
end


return MainMenuScene