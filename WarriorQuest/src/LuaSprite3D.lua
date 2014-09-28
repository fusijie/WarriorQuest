require("Helper")
local scheduler = cc.Director:getInstance():getScheduler()
----------------------------------------
----Manager
----------------------------------------
WarriorManager = List.new()
MonsterManager = List.new()
BossManager = List.new()

EnumRace = 
{ 
    "BASE",
    "WARRIOR", 
    "MONSTER",
    "BOSS", 
}

EnumState = 
{ 
    "STAND", 
    "WALK",
    "ATTACK", 
    "DEFEND",
    "KNOCKED",
    "DEAD",
}

EnumRace = CreateEnumTable(EnumRace) 
EnumState = CreateEnumTable(EnumState) 
----------------------------------------
----LuaSprite3D
----------------------------------------
LuaSprite3D = {node = 0, sprite3d = 0, scheduleAttackId = 0, target = 0, raceType = EnumRace.BASE, state = EnumState.STAND, alive = true, life = 100, speed = 100, attack = 30, priority = speed, action = {}}
LuaSprite3D.__index = LuaSprite3D

function LuaSprite3D:new(filename)
    local self = {}
    setmetatable(self, LuaSprite3D)
    self.action.stand = ""
    self.action.attack = filename
    self.action.walk = ""
    self.action.defend = ""    
        
    self.node = cc.Node:create();    
    local tempSprite = cc.Sprite:create("btn_circle_normal.png")
    self.node:addChild(tempSprite)
    tempSprite:setTag(2)
    tempSprite:setScale(0.03)
    
    local attackArea = cc.ProgressTimer:create(cc.Sprite:create("btn_circle_normal.png"))
    self.node:addChild(attackArea)
    attackArea:setTag(1)
    attackArea:setScale(0.035)
    attackArea:setColor(cc.c3b(255, 0, 0))
    attackArea:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    attackArea:runAction(cc.ProgressTo:create(0, 25))
    --attackArea:setPosition3D(cc.V3(0, 0, 0))
    --attackArea:setRotation(140)
    
    self.sprite3d  = cc.EffectSprite3D:create(filename)
    self.node:addChild(self.sprite3d)
    self.sprite3d:setTag(3)
        
    return self
end

function LuaSprite3D:setState(type)
    if self.state == type then
        return
    elseif type ~= EnumState.KNOCKED then
        self.sprite3d:stopActionByTag(self.state)    
        self.state = type
    end

    if type == EnumState.STAND then
        local standAction = cc.RotateTo:create(0.5, 0)
        standAction:setTag(self.state) 
        self.sprite3d:runAction(standAction) 
    end
    
    if type == EnumState.DEAD then
        local rotateAngle = nil
        if self.raceType == EnumRace.WARRIOR then
            rotateAngle = 90.0
        else 
            rotateAngle = -90.0
        end
        self.sprite3d:runAction(cc.RotateTo:create(0.02, rotateAngle))            
    end    
    
    if type == EnumState.WALK then
        local x = 0
        if self.raceType == EnumRace.WARRIOR then
            x = 10
        else
            x = -10
        end
        local walkAction = cc.JumpBy:create(0.5, cc.p(x,0), 5, 1)
        local repeatAction = cc.RepeatForever:create(walkAction)
        repeatAction:setTag(self.state) 
        self.sprite3d:runAction(repeatAction)   
    end 

    if type == EnumState.ATTACK then
        local animation = cc.Animation3D:create(self.action.attack)
        local animate = cc.Animate3D:create(animation)
        animate:setSpeed(self.speed)
        local repeatAction = cc.RepeatForever:create(animate)
        repeatAction:setTag(self.state) 
        self.sprite3d:runAction(repeatAction)
    end
    
    if type == EnumState.DEFEND then
        local x = 0
        if self.raceType == EnumRace.WARRIOR then
            x = -15
        else
            x = 15
        end
        local defendAction = cc.RotateBy:create(0.5, x)
        defendAction:setTag(self.state) 
        self.sprite3d:runAction(defendAction)     
    end   
    
    if type == EnumState.KNOCKED then
        if self.raceType == EnumRace.BOSS then
            local action = cc.Sequence:create(cc.MoveBy:create(0.05, cc.p(10,10)),  cc.MoveBy:create(0.05, cc.p(-10,-10)))
            self.sprite3d:runAction(action)
        else 
            self.sprite3d:runAction(cc.RotateBy:create(0.5, 360.0))
        end 
    end
end

function LuaSprite3D:setTarget(target)
    if self.target ~= target and target ~= 0 and target.alive then
    	self.target = target
    end
end

function LuaSprite3D:hurt(hurtCount)
    if self.alive == true then
        self.life = self.life - hurtCount
        if self.life > 0 then
            self:setState(EnumState.KNOCKED)
        else
            self.alive = false
            self:setState(EnumState.DEAD)
        end
    end
end
----------------------------------------
----Warrior3D
----------------------------------------
Warrior3D = {arm = "", chest = "", weapon = ""}
setmetatable(Warrior3D, LuaSprite3D)
Warrior3D.__index = Warrior3D

function Warrior3D:new(filename)
    local self = LuaSprite3D:new(filename)
    setmetatable(self, Warrior3D)
    local tempTalbe = self
    tempTalbe.arm = ""
    tempTalbe.chest = ""
    tempTalbe.weapon = math.random()..""     
    tempTalbe.attack = 1
    self.raceType = EnumRace.WARRIOR
    
    local function update(dt)
        self:FindEnemy2Attack()
    end
    
    scheduler:scheduleScriptFunc(update, 0.5, false)

    return self
end

function Warrior3D:FindEnemy2Attack()
    if self.alive == false then return end 
    
    if self.state == EnumState.ATTACK and self.scheduleAttackId == 0 then
        local function scheduleAttack(dt)
            if self.alive == false or (self.target == 0 and self.target.alive == false) then
                scheduler:unscheduleScriptEntry(self.scheduleAttackId)
                self.scheduleAttackId = 0
                return          
            end

            self.target:hurt(self.attack)
        end    
        self.scheduleAttackId = scheduler:scheduleScriptFunc(scheduleAttack, 1, false)            
    end
    
    if self.state ~= EnumState.ATTACK and self.scheduleAttackId ~= 0 then
        scheduler:unscheduleScriptEntry(self.scheduleAttackId)
        self.scheduleAttackId = 0
    end  
end

----------------------------------------
----Monster3D
----------------------------------------
Monster3D = {posion = ""}
setmetatable(Monster3D, LuaSprite3D)
Monster3D.__index = Monster3D

function Monster3D:new(filename)
    local self = LuaSprite3D:new(filename)
    setmetatable(self, Monster3D)    
    self.raceType = EnumRace.MONSTER
   
    local function update(dt)
        if self.alive == true then
            self:FindEnemy2Attack()          
        end
    end
       
    --scheduler:scheduleScriptFunc(update, 0.5, false)
   
    return self
end

function Monster3D:FindEnemy2Attack()
    if self.alive == false then return end 

    if self.target ~= 0 and self.target.alive then
        if self.state == EnumState.Attack then
            return
        end

        local x1, y1 = self.sprite3d:getPosition()
        local x2, y2 = self.target.sprite3d:getPosition()
        local distance = math.abs(x1-x2)

        if distance < 100 then
            self:setState(EnumState.ATTACK)

            local function scheduleAttack(dt)
                if self.alive == false or self.target == 0 or self.target.alive == false then
                    scheduler:unscheduleScriptEntry(self.scheduleAttackId)
                    self.scheduleAttackId = 0
                    return            
                end            
                local attacker = self
                local defender = self.target

                defender.life = defender.life - attacker.attack
                if defender.life > 0 then
                    defender.sprite3d:runAction(cc.RotateBy:create(0.5, 360.0))
                else
                    defender.alive = false
                    defender:setState(EnumState.DEAD)
                    attacker:setState(EnumState.STAND)
                end
            end

            self.scheduleAttackId = scheduler:scheduleScriptFunc(scheduleAttack, self.priority+5, false)            
        end  
    end

    self.target = findAliveWarrior()
end

----------------------------------------
----Boss3D
----------------------------------------
Boss3D = {extra = ""}
setmetatable(Boss3D, LuaSprite3D)
Boss3D.__index = Boss3D

function Boss3D:new(filename)
    local self = LuaSprite3D:new(filename)
    setmetatable(self, Boss3D)
    self.raceType = EnumRace.BOSS 

    local function update(dt)
        if self.alive == true then
            self:FindEnemy2Attack()
        end                  
    end
       
    --scheduler:scheduleScriptFunc(update, 0.5, false)
    
    return self
end

function Boss3D:FindEnemy2Attack()
    if self.alive == false then return end 

    if self.target ~= 0 and self.target.alive then
        if self.state == EnumState.Attack then
            return
        end

        local x1, y1 = self.sprite3d:getPosition()
        local x2, y2 = self.target.sprite3d:getPosition()
        local distance = math.abs(x1-x2)

        if distance < 100 then
            self:setState(EnumState.ATTACK)
            
            local function scheduleAttack(dt)
                if self.alive == false or self.target == 0 or self.target.alive == false then
                    scheduler:unscheduleScriptEntry(self.scheduleAttackId)
                    self.scheduleAttackId = 0
                    return            
                end
                            
                local attacker = self
                local defender = self.target

                defender.life = defender.life - attacker.attack
                if defender.life > 0 then
                    defender.sprite3d:runAction(cc.RotateBy:create(0.5, 360.0))
                else
                    defender.alive = false
                    defender:setState(EnumState.DEAD)
                    attacker:setState(EnumState.STAND)
                end
            end

            self.scheduleAttackId = scheduler:scheduleScriptFunc(scheduleAttack, self.priority+5, false)            
        end  
    end

    self.target = findAliveWarrior()
end

function findAliveMonster()
    for val = 1, List.getSize(MonsterManager) do
        if MonsterManager[val-1].alive == true then
            return MonsterManager[val-1]
        end                  
    end

    return 0
end

function findAliveWarrior()
    for val = 1, List.getSize(WarriorManager) do
        if WarriorManager[val-1].alive == true then
            return WarriorManager[val-1]
        end                  
    end  

    return 0
end

function findAliveBoss()
    for val = 1, List.getSize(BossManager) do
        if BossManager[val-1].alive == true then
            return BossManager[val-1]
        end                  
    end  

    return 0
end

function tooClose(object1, object2)
--    local aaa = object1.sprite3d:getBoundingBox()
--    local bbb = object2.sprite3d:getBoundingBox()
--    local miniDistance = (aaa.width + bbb.width)/2
    local miniDistance = 2
    local startP = object1.node:getPosition3D()
    local endP = object2.node:getPosition3D()

    local tempDistance = cc.pGetDistance(cc.p(startP.x, startP.z), cc.p(endP.x, endP.z))
    if tempDistance < miniDistance then
        local tempX, tempZ
        if startP.x > endP.x then
            tempX = startP.x - endP.x                
        else
            tempX = endP.x - startP.x
        end

        if startP.z > endP.z then
            tempZ =  startP.z - endP.z                
        else
            tempZ = endP.z - startP.z
        end

        local ratio = (miniDistance - tempDistance) / miniDistance
        tempX = ratio * tempX + tempX * 0.01
        tempZ = ratio * tempZ + tempZ * 0.01
        if tempX == 0 then tempX = 0.01 end  -- setPosition3D doesn't work when only z is changed      
    
        if startP.x > endP.x then
            startP.x = startP.x + tempX/2
            endP.x = endP.x - tempX/2
        else
            startP.x = startP.x - tempX/2
            endP.x = endP.x + tempX/2                                        
        end

        if startP.z > endP.z then
            startP.z = startP.z + tempZ/2
            endP.z = endP.z - tempZ/2
        else
            startP.z = startP.z - tempZ/2
            endP.z = endP.z + tempZ/2                                        
        end                

        object1.node:setPosition3D(startP)
        object2.node:setPosition3D(endP)
    elseif tempDistance < miniDistance + 0.02 then           
        --cclog("i'm ready for attack")
        if object1.raceType ~= object2.raceType then
            object1:setState(EnumState.ATTACK)
            object1:setTarget(object2)        	
        end
    else
        if object1.target == object2 then
            object2:setState(EnumState.STAND)
        end
    end  
end

function collisionDetectWarrior(Object)
    for val = 1, List.getSize(WarriorManager) do
        local sprite = WarriorManager[val-1]
        if sprite.alive == true and sprite ~= Object then
             tooClose(sprite, Object)
        end
    end
    
    for val = 1, List.getSize(MonsterManager) do
        local sprite = MonsterManager[val-1]
        if sprite.alive == true and sprite ~= Object then
            tooClose(sprite, Object)
        end                  
    end 
    
    for val = 1, List.getSize(BossManager) do
        local sprite = BossManager[val-1]
        if sprite.alive == true and sprite ~= Object then
            tooClose(sprite, Object)
        end
    end     
end
