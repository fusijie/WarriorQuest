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
    "MOSTER",
    "BOSS", 
}

EnumRace = CreateEnumTable(EnumRace) 

----------------------------------------
----LuaSprite3D
----------------------------------------
LuaSprite3D = {sprite3d = 0, battelScene = 0, target = 0, raceType=EnumRace.BASE, alive = true, life = 100, speed = 100, attack = 50, priority = speed, skill = {}}
LuaSprite3D.__index = LuaSprite3D

function LuaSprite3D:new(scene, filename)
    local self = {}
    setmetatable(self, LuaSprite3D)
    self.battelScene = scene
    self.sprite3d = EffectSprite3D:create(filename)           
    return self
end

----------------------------------------
----Warrior3D
----------------------------------------
Warrior3D = {arm = "", chest = "", weapon = ""}
setmetatable(Warrior3D, LuaSprite3D)
Warrior3D.__index = Warrior3D

function Warrior3D:new(scene, filename)
    local self = LuaSprite3D:new(scene, filename)
    setmetatable(self, Warrior3D)
    local tempTalbe = self
    tempTalbe.arm = ""
    tempTalbe.chest = ""
    tempTalbe.weapon = math.random()..""     
    tempTalbe.attack = 80
    self.raceType = EnumRace.WARRIOR

    return self
end

function Warrior3D:update(dt)
    for val = 1, List.getSize(WarriorManager) do
        if WarriorManager[val-1].alive == true then
            WarriorManager[val-1]:FindEnemy2Attack()
        end                  
    end
end

function Warrior3D:FindEnemy2Attack()
    if self.alive == false then return end 

    if self.target ~= 0 and self.target.alive then
        self.sprite3d:stopActionByTag(95558)
        cclog("%s %f %f", self.weapon, self.target.sprite3d:getPosition())
        local time = cc.pGetDistance( cc.p(self.sprite3d:getPosition()), 
                                     cc.p(self.target.sprite3d:getPosition()) ) / 50
                                     
        local x, y = self.target.sprite3d:getPosition()
        local moveAction = cc.MoveTo:create(time, cc.p(x - 50, y))
        moveAction:setTag(95558)
        self.sprite3d:runAction(moveAction)
        return  
    end

    self.target = findAliveMonster()

    if self.target == 0 then
        self.target = findAliveBoss()
    end   
end

scheduler:scheduleScriptFunc(Warrior3D.update, 0.5, false)


----------------------------------------
----Monster3D
----------------------------------------
Monster3D = {posion = ""}
setmetatable(Monster3D, LuaSprite3D)
Monster3D.__index = Monster3D

function Monster3D:new(scene, filename)
    local self = LuaSprite3D:new(scene, filename)
    setmetatable(self, Monster3D)    
    self.raceType = EnumRace.MONSTER
   
    return self
end

function Monster3D:update(dt)
    for val = 1, List.getSize(MonsterManager) do
        if MonsterManager[val-1].alive == true then
            MonsterManager[val-1]:FindEnemy2Attack()
        end                  
    end
end

function Monster3D:FindEnemy2Attack()
    if self.alive == false then return end 

    if self.target ~= 0 and self.target.alive then
        self.sprite3d:stopActionByTag(95558)
        cclog("%s %f %f", self.weapon, self.target.sprite3d:getPosition())
        local time = cc.pGetDistance( cc.p(self.sprite3d:getPosition()), 
            cc.p(self.target.sprite3d:getPosition()) ) / 50

        local x, y = self.target.sprite3d:getPosition()
        local moveAction = cc.MoveTo:create(time, cc.p(x + 50, y))
        moveAction:setTag(95558)
        self.sprite3d:runAction(moveAction)
        return  
    end

    self.target = findAliveWarrior()
end

scheduler:scheduleScriptFunc(Monster3D.update, 0.5, false)

----------------------------------------
----Boss3D
----------------------------------------
Boss3D = {extra = ""}
setmetatable(Boss3D, LuaSprite3D)
Boss3D.__index = Boss3D

function Boss3D:new(scene, filename)
    local self = LuaSprite3D:new(scene, filename)
    setmetatable(self, Boss3D)
    self.raceType = EnumRace.BOSS 

    return self
end

function Boss3D:update(dt)
    for val = 1, List.getSize(BossManager) do
        if BossManager[val-1].alive == true then
            BossManager[val-1]:FindEnemy2Attack()
        end                  
    end
end

function Boss3D:FindEnemy2Attack()
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