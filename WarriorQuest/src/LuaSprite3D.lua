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
    "DEAD",
}

EnumRace = CreateEnumTable(EnumRace) 
EnumState = CreateEnumTable(EnumState) 
----------------------------------------
----LuaSprite3D
----------------------------------------
LuaSprite3D = {sprite3d = 0, scheduleAttackId = 0, target = 0, drawDebug = 0, obbt = 0, raceType=EnumRace.BASE, stateType = EnumState.STAND, alive = true, life = 100, speed = 100, attack = 30, priority = speed, action = {}}
LuaSprite3D.__index = LuaSprite3D

function LuaSprite3D:new(filename)
    local self = {}
    setmetatable(self, LuaSprite3D)
    self.sprite3d = cc.EffectSprite3D:create(filename)    
    self.action.stand = ""
    self.action.attack = filename
    self.action.walk = ""
    self.action.defend = ""
    
    local aa = self.sprite3d:getAABB()
    self.obbt = cc.OBB:new(aa)
    self.drawDebug = cc.DrawNode3D:create()
    self.sprite3d:addChild(self.drawDebug)
    self.drawDebug:setScale(2)
    
    return self
end

function LuaSprite3D:setState(type)
    if self.stateType == type then
        return
    else
        self.sprite3d:stopActionByTag(self.stateType)    
        self.stateType = type
    end

    if type == EnumState.STAND then
        local standAction = cc.RotateTo:create(0.5, 0)
        standAction:setTag(self.stateType) 
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
        repeatAction:setTag(self.stateType) 
        self.sprite3d:runAction(repeatAction)   
    end 

    if type == EnumState.ATTACK then
        local animation = cc.Animation3D:create(self.action.attack)
        local animate = cc.Animate3D:create(animation)
        animate:setSpeed(self.speed)
        local repeatAction = cc.RepeatForever:create(animate)
        repeatAction:setTag(self.stateType) 
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
        defendAction:setTag(self.stateType) 
        self.sprite3d:runAction(defendAction)     
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
    tempTalbe.attack = 50
    self.raceType = EnumRace.WARRIOR
    
    local function update(dt)
        if self.alive == true then
            self:FindEnemy2Attack()             
        end                  
        
        self.drawDebug:clear()
        local mat = self.sprite3d:getNodeToWorldTransform()
        cc.V3Assign(self.obbt._xAxis, cc.Mat4getRightVector(mat))         
        cc.V3Normalize(self.obbt._xAxis)

        cc.V3Assign(self.obbt._yAxis, cc.Mat4getUpVector(mat))
        cc.V3Normalize(self.obbt._yAxis)

        cc.V3Assign(self.obbt._zAxis, cc.Mat4getForwardVector(mat))
        cc.V3Normalize(self.obbt._zAxis)

        cc.V3Assign(self.obbt._center, self.drawDebug:getPosition3D())

        local corners = cc.V3Array(8)            
        corners = self.obbt:getCorners(corners)
        self.drawDebug:drawCube(corners, cc.c4f(0,0,1,1))
        printTab(self.obbt._center)          
    end

    scheduler:scheduleScriptFunc(update, 0.5, false)

    return self
end

function Warrior3D:FindEnemy2Attack()
    if self.alive == false then return end 

    if self.target ~= 0 and self.target.alive then
        if self.stateType == EnumState.Attack then
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
                    if defender.raceType == EnumRace.BOSS then
                        local action = cc.Sequence:create(cc.MoveBy:create(0.05, cc.p(10,10)),  cc.MoveBy:create(0.05, cc.p(-10,-10)))
                        defender.sprite3d:runAction(action)
                    else 
                        defender.sprite3d:runAction(cc.RotateBy:create(0.5, 360.0))
                    end     
                else
                    defender.alive = false
                    defender:setState(EnumState.DEAD)
                    attacker:setState(EnumState.STAND)
                end
            end
            
            self.scheduleAttackId = scheduler:scheduleScriptFunc(scheduleAttack, self.priority+5, false)            
        end  
    end

    self.target = findAliveMonster()

    if self.target == 0 then
        self.target = findAliveBoss()
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
            local mat = self.sprite3d:getNodeToWorldTransform()
            self.obbt._xAxis = cc.Mat4getRightVector(mat)
            cc.V3Normalize(self.obbt._xAxis)
            
            self.obbt._yAxis = cc.Mat4getUpVector(mat)
            cc.V3Normalize(self.obbt._yAxis)
            
            self.obbt._zAxis = cc.Mat4getForwardVector(mat)
            cc.V3Normalize(self.obbt._zAxis)
            
            self.obbt._center = self.drawDebug:getPosition3D()
            local corners = self.obbt:getCorners()
            self.drawDebug:drawCube(corners, cc.c4f(0,0,1,1))           
        end
    end
       
    scheduler:scheduleScriptFunc(update, 0.5, false)
   
    return self
end

function Monster3D:FindEnemy2Attack()
    if self.alive == false then return end 

    if self.target ~= 0 and self.target.alive then
        if self.stateType == EnumState.Attack then
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
       
    scheduler:scheduleScriptFunc(update, 0.5, false)
    
    return self
end

function Boss3D:FindEnemy2Attack()
    if self.alive == false then return end 

    if self.target ~= 0 and self.target.alive then
        if self.stateType == EnumState.Attack then
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