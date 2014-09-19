require "Helper"
require("LuaSprite3D")

local size = cc.Director:getInstance():getWinSize()
local scheduler = cc.Director:getInstance():getScheduler()
local schedulerEntry = nil
local warrior3DTag = 10086
local monster3DTag = 10010
local boss3DTag = 10000
local spriteBg = nil
local battleStep = 1
local gloableZOrder = 1
local camera = nil 
local touchPos = nil
local beginUpdate = false

local BattleFieldScene = class("BattleFieldScene",function()
    return cc.Scene:create()
end)

----------------------------------------
----Sprite3DWithSkinTest
----------------------------------------
local Sprite3DWithSkinTest = {currentLayer = nil}
Sprite3DWithSkinTest.__index = Sprite3DWithSkinTest


local function isOutOfBound()
    local playser = WarriorManager[0].sprite3d
    
    local currentPos = playser:getPosition3D();
    local state = false;

    if currentPos.x < -10.5 then
        currentPos.x = -10.5
        state = true
        beginUpdate = false
    end    

    if currentPos.x > 9.5 then
        currentPos.x = 9.5
        state = true
        beginUpdate = false
    end

    if currentPos.z < -3.0 then
        currentPos.z = -3.0
        state = true
        beginUpdate = false
    end

    if currentPos.z > 7.0 then
        currentPos.z = 7.0
        state = true
        beginUpdate = false
    end

    playser:setPosition3D(currentPos)
    return state;
end

local function update(dt)
    if List.getSize(WarriorManager) == 0 or isOutOfBound() then return end
    
    local playser = WarriorManager[0].sprite3d
    if beginUpdate then
        local position = playser:getPosition3D()
        local dir = cc.V3Sub(touchPos, position) 
    	cc.V3Normalize(dir)
    	local dp = cc.V3MulEx(dir, 5.0*dt)
        local endPos = cc.V3Add(position, dp)
        if cc.V3LengthSquared(cc.V3Sub(endPos, touchPos)) <= cc.V3LengthSquared(dp) then
        	if cc.V3Dot(cc.V3Sub(endPos, touchPos), dir) then
        		endPos = touchPos
        		beginUpdate = false
        	end
        end
        
        if endPos.y < 0 then endPos.y = 0 end
        
    	playser:setPosition3D(endPos)
    	--cclog("%.2f %.2f %.2f", endPos.x, endPos.y, endPos.z)
    	local aspect = cc.V3Dot(dir, cc.V3(0.0, 0.0, 1.0))
    	aspect = math.acos(aspect)
    	if dir.x < 0.0 then	aspect = -aspect end
    	playser:setRotation3D(cc.V3(0.0, aspect * 57.29577951 +180.0, 0.0))
    	
    	if camera then
            local position = playser:getPosition3D()
            camera:lookAt(position, cc.V3(0.0, 1.0, 0.0))
            camera:setPosition3D(cc.V3Add(position, cc.V3(0.0, 10.0, 10.0)))
    	end
    end
end


function Sprite3DWithSkinTest.addNewSpriteWithCoords(parent, x, y, tag)
    y = y+70
    local sprite = nil
    local animation = nil
    if tag == warrior3DTag then
        sprite = Warrior3D:new("Sprite3DTest/orc.c3b")
        --sprite.sprite3d:setScale(3)
        List.pushlast(WarriorManager, sprite)
    elseif tag == monster3DTag then
        sprite = Monster3D:new("Sprite3DTest/orc.c3b")    
        sprite.sprite3d:setScale(3)   
        List.pushlast(MonsterManager, sprite)
    elseif tag == boss3DTag then
        sprite = Boss3D:new("Sprite3DTest/girl.c3b")        
        List.pushlast(BossManager, sprite)
    else
        return
    end

    sprite.sprite3d:setRotation3D({x = 0, y = 180, z = 0})
    
    local positionX, positionY = parent:getPosition()
    sprite.sprite3d:setScale(0.1)
    --sprite.sprite3d:setPosition(cc.p(x - positionX, y - positionY))
    gloableZOrder = gloableZOrder + 1
    sprite.sprite3d:setGlobalZOrder(gloableZOrder)
    parent:addChild(sprite.sprite3d)
    sprite.sprite3d:setTag(tag);
    --BattleFieldScene.createRandomDebut(sprite.sprite3d, sprite.sprite3d:getPosition())        
    
    local effect  = cc.Effect3DOutline:create()
    local tempColor = {x=1,y=0,z=0}
    effect:setOutlineColor(tempColor)
    effect:setOutlineWidth(0.01)
    sprite.sprite3d:addEffect(effect, -1)
   
    local rand2 = math.random()
    local speed = 1.0
    
    if rand2 < 1/3 then
        speed =  math.random()  
    elseif rand2 < 2/3 then
        speed = - 0.5 *  math.random()
    end

    sprite.speed =  speed + 0.5
    sprite.priority = sprite.speed        
    
    sprite:setState(EnumState.STAND)
end

function Sprite3DWithSkinTest.create(layer)
    Sprite3DWithSkinTest.currentLayer = layer
 
    Sprite3DWithSkinTest.addNewSpriteWithCoords(spriteBg, size.width / 2 - 300, size.height / 4 + 40, warrior3DTag)
    --Sprite3DWithSkinTest.addNewSpriteWithCoords(spriteBg, size.width / 2 - 260, size.height / 4 + 10, warrior3DTag)
    --Sprite3DWithSkinTest.addNewSpriteWithCoords(spriteBg, size.width / 2 - 300, size.height / 4 - 20, warrior3DTag)

    return layer
end


function BattleFieldScene:createBackground(layer)
    spriteBg = cc.Sprite3D:create("Sprite3DTest/scene/DemoScene.c3b")
    local children = spriteBg:getChildren()
    layer:addChild(spriteBg);
end

function BattleFieldScene.setCamera(layer)
    camera = cc.Camera:createPerspective(60.0, size.width/size.height, 1.0, 1000.0)
    camera:setCameraFlag(2)
    camera:setPosition3D(cc.V3(0.0, 10.0, 10.0))
    camera:lookAt(cc.V3(0.0, 0.0, 0.0), cc.V3(0.0, 1.0, 0.0))
    layer:addChild(camera)
end

function BattleFieldScene.create()
    local scene = BattleFieldScene:new()
    local layer = cc.Layer:create()
    scene:addChild(layer)
--    layer:setScale(2)
    
    BattleFieldScene:createBackground(layer)
    BattleFieldScene.setCamera(layer)
    Sprite3DWithSkinTest.create(layer)
    layer:setCameraMask(2);

    --button
    local function touchEvent_return(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local scene = require("ChooseRoleScene")
            cc.Director:getInstance():replaceScene(scene.create())
        end
    end  

    local return_Button = ccui.Button:create()
    return_Button:setTouchEnabled(true)
    return_Button:loadTextures("cr_btn_normal.png", "cr_btn_pressed.png", "")
    return_Button:setTitleText("Return")
    return_Button:setAnchorPoint(0,1)
    
    return_Button:setPosition(size.width / 2 - 300, size.height  - 200)
    return_Button:addTouchEventListener(touchEvent_return)        
    layer:addChild(return_Button, 10)
    return_Button:setScale(0.5)

    --local moveBack = cc.EaseSineInOut:create(cc.MoveBy:create(2.0, cc.p(177, 0)))
    --local moveFunction = cc.CallFunc:create(BattleFieldScene.moveForth)
    --layer:runAction(cc.Sequence:create(moveBack, cc.DelayTime:create(1.0), moveFunction));
    
    local function battle_success(event)
        BattleFieldScene.success()
    end
    
    local function battle_fail(event)
        BattleFieldScene.fail()
    end    
        
    local listener1 = cc.EventListenerCustom:create("battle_success", battle_success)
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener1, 1)
    
    local listener2 = cc.EventListenerCustom:create("battle_fail", battle_fail)
    eventDispatcher:addEventListenerWithFixedPriority(listener2, 2)    
    
    -- handling touch events   
    local function onTouchBegan(touch, event)
        return true
    end
    
    local function onTouchMoved(touches, event)     
    end    

    local function onTouchEnded(touch, event)
        if touch == nil then return end

        local location = touch:getLocationInView()
        local nearP = cc.V3(location.x, location.y, -1.0)
        local farP = cc.V3(location.x, location.y, 1.0)
        nearP = camera:unproject(size, nearP, nearP)
        farP = camera:unproject(size, farP, farP)
    
        local dir = cc.V3Sub(farP, nearP)
        local dist = 0.0
        local temp = cc.V3(0.0, 1.0, 0.0)
        local ndd = cc.V3Dot(temp, dir)
    
        if ndd == 0 then dist = 0.0 end
        
        local ndo = cc.V3Dot(temp, nearP)
        dist = (0 - ndo) / ndd
        
        local tt = cc.V3MulEx(dir, dist)
        touchPos =  cc.V3Add(nearP, tt)
        
        WarriorManager[0].sprite3d:runAction(cc.JumpBy:create(0.5, cc.p(0, 0), 5, 1))
        WarriorManager[0].sprite3d:runAction(cc.MoveTo:create(0.5, touchPos))
        beginUpdate = true;       
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCHES_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    scheduler:scheduleScriptFunc(update, 0, false)

    return scene
end

function BattleFieldScene.moveForth()
    Sprite3DWithSkinTest.currentLayer:removeChildByTag(monster3DTag)
    Sprite3DWithSkinTest.currentLayer:removeChildByTag(monster3DTag)
    Sprite3DWithSkinTest.currentLayer:removeChildByTag(monster3DTag)

    local x, y = spriteBg:getPosition()

    if x < 300 then
--    if x > 500 then
        return    
    end
     
    --background move forth
    local move = cc.EaseSineInOut:create(cc.MoveBy:create(5.0, cc.p(-50, 0)))
    local monsterFunction = cc.CallFunc:create(BattleFieldScene.monsterDebut)
    spriteBg:runAction(cc.Sequence:create(move, monsterFunction))
    
end

function BattleFieldScene.monsterDebut()
    --moster group1
    if battleStep == 1 then
        local layer = Sprite3DWithSkinTest.currentLayer 
        Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 + 300, size.height / 4 + 40, monster3DTag)
        Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 + 250, size.height / 4 + 10, monster3DTag)
        Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 + 300, size.height / 4 - 20, monster3DTag)
    end
   
    --monster group2
    if battleStep == 2 then
        local layer = Sprite3DWithSkinTest.currentLayer 
        Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 + 200, size.height / 4 + 40, monster3DTag)
        Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 + 250, size.height / 4 + 10, monster3DTag)
        Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 + 300, size.height / 4 - 20, monster3DTag)
    end
        
    --monster group3 with boss
    if battleStep == 3 then
        local layer = Sprite3DWithSkinTest.currentLayer 
        Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 + 300, size.height / 4 + 40, monster3DTag)
        Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 + 250, size.height / 4 + 10, monster3DTag)
        Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 + 300, size.height / 4 - 20, monster3DTag)
        Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 + 200, size.height / 4 + 10, boss3DTag)
    end 
        
    battleStep = battleStep + 1             
        
    schedulerEntry = scheduler:scheduleScriptFunc(BattleFieldScene.nextRound, 0.5, false)
end

function BattleFieldScene.nextRound()
    if findAliveMonster() == 0 and findAliveBoss() == 0 then
    	BattleFieldScene.success()
        scheduler:unscheduleScriptEntry(schedulerEntry)
    	return
    end
    
    if findAliveWarrior() == 0 then
        BattleFieldScene.fail()
        scheduler:unscheduleScriptEntry(schedulerEntry)
        return
    end    
    
    --local priority = findNextPriority()
    --BattleFieldScene.prepareCombat(priority)
    
    --schedulerEntry = scheduler:scheduleScriptFunc(BattleFieldScene.combat, priority + 1.0, false)
end


function BattleFieldScene.success()
    local successLabel = cc.Label:createWithTTF("Warrior SUCCESS!!!", "fonts/Marker Felt.ttf", 18)
    
    successLabel:setPosition(size.width / 2 - 100, size.height / 2)
    Sprite3DWithSkinTest.currentLayer:addChild(successLabel)
    
    local spawnAction = cc.Spawn:create(cc.ScaleBy:create(3.0, 3.0), cc.FadeOut:create(3.0))
    local action = cc.Sequence:create(showAction, spawnAction)

    successLabel:runAction(cc.Sequence:create(action, cc.RemoveSelf:create()))
    
    List.removeAll(MonsterManager)
    
    BattleFieldScene.restore()
    
    BattleFieldScene.moveForth()    
end

function BattleFieldScene.restore()
    for val = 1, List.getSize(WarriorManager) do
       WarriorManager[val-1].life = 100
       WarriorManager[val-1].alive = true
       WarriorManager[val-1]:setState(EnumState.STAND)
       WarriorManager[val-1]:setState(EnumState.WALK)
    end  
end

function BattleFieldScene.fail()
    local failLabel = cc.Label:createWithTTF("YOU LOSE!!!", "fonts/Marker Felt.ttf", 18)
    failLabel:setTextColor(cc.c4b(255, 0, 0, 255))
    failLabel:setPosition(size.width / 2 - 100, size.height / 2)
    Sprite3DWithSkinTest.currentLayer:addChild(failLabel)

    local action = cc.Sequence:create(showAction, cc.ScaleBy:create(3.0, 3.0))

    failLabel:runAction(action)
end

function BattleFieldScene.createRandomDebut(sprite, x,y)
    math.randomseed(os.clock())
    local tempRand = math.random(0,1)
    
    local actionDebut    
    if tempRand < 1/2 then
        sprite:setPosition(cc.p(1000, y))
        actionDebut = cc.MoveTo:create(2.0, cc.p(x, y))
    else
        sprite:setPosition(cc.p(x, 1000))
        actionDebut = cc.MoveTo:create(2.0, cc.p(x, y))
    end
    
    local rotateAction = cc.RotateBy:create(2.0, 720)
    local spawnAction = cc.Spawn:create(rotateAction, actionDebut)
    actionDebut = cc.EaseSineInOut:create(spawnAction)

    sprite:runAction(actionDebut)
end

return BattleFieldScene
