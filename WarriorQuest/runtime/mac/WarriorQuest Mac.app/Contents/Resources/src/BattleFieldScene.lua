require "Helper"
require("LuaSprite3D")

local size = cc.Director:getInstance():getWinSize()
local scheduler = cc.Director:getInstance():getScheduler()
local schedulerEntry = nil
local attacker = nil
local defender = nil    
local isWarriorAttack = true
local warrior3DTag = 10086
local monster3DTag = 10010
local boss3DTag = 10000
local animationTag = 95555
local moveActionTag = 95558
local spriteBg = nil
local battleStep = 1
local enemy = nil  
local gloableZOrder = 1
--local bUpdate = true  

local BattleFieldScene = class("BattleFieldScene",function()
    return cc.Scene:create()
end)

----------------------------------------
----Sprite3DWithSkinTest
----------------------------------------
local Sprite3DWithSkinTest = {currentLayer = nil}
Sprite3DWithSkinTest.__index = Sprite3DWithSkinTest


local function update(dt)
   
end

function Sprite3DWithSkinTest.addNewSpriteWithCoords(parent, x, y, tag)
    y = y+70
    local sprite = nil
    local animation = nil
    if tag == warrior3DTag then
        sprite = Warrior3D:new("Sprite3DTest/orc.c3b")
        sprite.sprite3d:setScale(3)
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
    sprite.sprite3d:setPosition(cc.p(x - positionX, y - positionY))
    gloableZOrder = gloableZOrder + 1
    sprite.sprite3d:setGlobalZOrder(gloableZOrder)
    parent:addChild(sprite.sprite3d)
    sprite.sprite3d:setTag(tag);
    --BattleFieldScene.createRandomDebut(sprite.sprite3d, sprite.sprite3d:getPosition())        
    
    local effect  = Effect3DOutline:create()
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
    
    sprite:setState(EnumState.WALK)
end

function Sprite3DWithSkinTest.create(layer)
    Sprite3DWithSkinTest.currentLayer = layer
 
    Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 - 300, size.height / 4 + 40, warrior3DTag)
    Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 - 260, size.height / 4 + 10, warrior3DTag)
    Sprite3DWithSkinTest.addNewSpriteWithCoords(layer, size.width / 2 - 300, size.height / 4 - 20, warrior3DTag)

    return layer
end


function BattleFieldScene:createBackground(layer)
    spriteBg = cc.Sprite:create("background.jpg")
    spriteBg:setPosition(size.width / 2 + 80, size.height / 2 + 30)
    layer:addChild(spriteBg)
    
    spriteBg:setRotation3D({x = -25.0, y = 0.0 ,z = 0.0});    
end



function BattleFieldScene.create()
    local scene = BattleFieldScene:new()
    local layer = cc.Layer:create()
    scene:addChild(layer)
    layer:setScale(2)
        
    BattleFieldScene:createBackground(layer)
    Sprite3DWithSkinTest.create(layer)
    
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

    local moveBack = cc.EaseSineInOut:create(cc.MoveBy:create(2.0, cc.p(177, 0)))
    local moveFunction = cc.CallFunc:create(BattleFieldScene.moveForth)
    layer:runAction(cc.Sequence:create(moveBack, cc.DelayTime:create(1.0), moveFunction));
    
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
        
    --schedulerEntry = scheduler:scheduleScriptFunc(BattleFieldScene.nextRound, 0.5, false)
end

function BattleFieldScene.nextRound()
    if findAliveMonster() == 0 and findAliveBoss() == 0 then
    	BattleFieldScene.success()
    	return
    end
    
    if findAliveWarrior() == 0 then
        BattleFieldScene.fail()
        return
    end    
    
    --local priority = findNextPriority()
    --BattleFieldScene.prepareCombat(priority)
    
    --schedulerEntry = scheduler:scheduleScriptFunc(BattleFieldScene.combat, priority + 1.0, false)
end
--[[
function findNextPriority()
    local nextPriority = 2
    if List.getSize(MonsterManager) > 0 then
        for val = 1, List.getSize(WarriorManager) do
            if MonsterManager[val-1].priority < nextPriority and MonsterManager[val-1].alive == true then
                nextPriority = MonsterManager[val-1].priority
            end
        end
    end

    if List.getSize(WarriorManager) > 0 then
        for val = 1, List.getSize(WarriorManager) do
            if WarriorManager[val-1].priority < nextPriority and WarriorManager[val-1].alive == true then
                nextPriority = WarriorManager[val-1].priority
            end                  
        end
    end

    if List.getSize(BossManager) > 0 then
        for val = 1, List.getSize(BossManager) do
            if BossManager[val-1].priority < nextPriority and BossManager[val-1].alive == true then
                nextPriority = BossManager[val-1].priority
            end                  
        end
    end	
    
    return nextPriority
end

function BattleFieldScene.prepareCombat(nextPriority)
    attacker = nil

    for val = 1, List.getSize(MonsterManager) do
        MonsterManager[val-1].priority = MonsterManager[val-1].priority - nextPriority
        if MonsterManager[val-1].priority == 0 and MonsterManager[val-1].alive then
            if attacker == nil then 
                isWarriorAttack = false
                MonsterManager[val-1].priority = MonsterManager[val-1].speed
                attacker = MonsterManager[val-1]
            end
        end
    end  

    for val = 1, List.getSize(WarriorManager) do
        WarriorManager[val-1].priority = WarriorManager[val-1].priority - nextPriority
        if WarriorManager[val-1].priority == 0 and WarriorManager[val-1].alive then
            if attacker == nil then
                isWarriorAttack = true      
                WarriorManager[val-1].priority = WarriorManager[val-1].speed
                attacker = WarriorManager[val-1]
            end
        end                  
    end

    for val = 1, List.getSize(BossManager) do
        BossManager[val-1].priority = BossManager[val-1].priority - nextPriority
        if BossManager[val-1].priority == 0 and BossManager[val-1].alive then
            if attacker == nil then  
                isWarriorAttack = false
                BossManager[val-1].priority = BossManager[val-1].speed
                attacker = BossManager[val-1]
            end
        end                  
    end
end

function BattleFieldScene.combat(dt)
    scheduler:unscheduleScriptEntry(schedulerEntry)
    defender = nil
    if isWarriorAttack then
        defender = findAliveMonster()
        if defender == 0 then
            defender = findAliveBoss()
        end          
    else
        defender = findAliveWarrior()    
    end
    
    if defender ~= nil then
        local x1, y1 = attacker.sprite3d:getPosition()
        local x2, y2 = defender.sprite3d:getPosition()

        if isWarriorAttack then
            x2 = x2 - 50
        else
            x2 = x2 + 50
        end
        
        local attackAction = cc.Sequence:create(cc.MoveBy:create(1.0, cc.p(10,10)),  cc.MoveBy:create(1.0, cc.p(-10,-10)))        
        local hurtFunction = cc.CallFunc:create(BattleFieldScene.hurt)
        local nextFunction = cc.CallFunc:create(BattleFieldScene.nextRound)
        attacker.sprite3d:runAction(cc.Sequence:create(attackAction, hurtFunction, nextFunction))                
    end    
end

function BattleFieldScene.hurt()
    defender.life = defender.life - attacker.attack
    if defender.life > 0 then
        if defender.raceType == EnumRace.BOSS then
            local action = cc.Sequence:create(cc.MoveBy:create(0.05, cc.p(10,10)),  cc.MoveBy:create(0.05, cc.p(-10,-10)))
            defender.sprite3d:runAction(action)
        else 
            defender.sprite3d:runAction(cc.RotateBy:create(1.0, 360.0))
        end     
    else
        defender.alive = false
        
        local rotateAngle = nil
        if isWarriorAttack then
            rotateAngle = 90.0
        else 
            rotateAngle = -90.0
        end
        defender.sprite3d:runAction(cc.RotateBy:create(1.0, rotateAngle))            
        defender.sprite3d:stopActionByTag(animationTag)
    end
end
--]]

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
       
       if WarriorManager[val-1].alive == false then
            WarriorManager[val-1].alive = true
            WarriorManager[val-1].sprite3d:runAction(cc.RotateBy:create(1.0, 90)) 
       end
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
