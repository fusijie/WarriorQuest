require "Helper"

--type

EnumRaceType = 
{ 
    "BASE",
    "HERO", 
    "WARRIOR",
    "ARCHER",
    "SORCERESS",
    "MONSTER",
    "BOSS", 
}
EnumRaceType = CreateEnumTable(EnumRaceType) 

EnumStateType =
{
    "STAND",
    "WALK",
    "ATTACK",
    "DEFEND",
    "DEAD",
}
EnumStateType = CreateEnumTable(EnumStateType) 



local Base3D = class ("Base3D", function ()
	return cc.Node:create()
end)

function Base3D:ctor()
	self._isalive = true
	self._blood = 1000
	self._attack = 100
	self._defense = 100
	self._speed = 100
	self._priority = self._speed
    self._racetype = EnumRaceType.BASE
    self._statetype = EnumStateType.STAND
    self._sprite3d = nil
    self._circle = nil
    self._scheduleAttackId = 0
    self._target = 0
    self._action = {stand="", attack="", walk="", defend=""}
end

function Base3D.create()
	
    local base = Base3D.new()	
    base:addCircle()
	return base
end

function Base3D:addCircle()
	self._circle = cc.Sprite:create("btn_circle_normal.png")
	self._circle:setScale(0.3)
	self:addChild(self._circle)
end

function Base3D:setState(type)
    if self:getStateType() == type then
        return
    else
        self:stopActionByTag(self:getStateType())    
        self:setStateType(type)
    end

    if type == EnumStateType.STAND then
        local standAction = cc.RotateTo:create(0.5, 0)
        standAction:setTag(self:getStateType()) 
        self:runAction(standAction) 
    end

    if type == EnumStateType.DEAD then
        local rotateAngle = nil
        if self:getRaceType() == EnumRaceType.HERO then
            rotateAngle = 90.0
        else 
            rotateAngle = -90.0
        end
        self.sprite3d:runAction(cc.RotateTo:create(0.02, rotateAngle))            
    end    

    if type == EnumStateType.WALK then
        local x = 0
        if self:getRaceType() == EnumRaceType.HERO then
            x = 10
        else
            x = -10
        end
        local walkAction = cc.JumpBy:create(0.5, cc.p(x,0), 5, 1)
        local repeatAction = cc.RepeatForever:create(walkAction)
        repeatAction:setTag(self:getStateType()) 
        self.sprite3d:runAction(repeatAction)   
    end 

    if type == EnumStateType.ATTACK then
        local animation = cc.Animation3D:create(self.action.attack)
        local animate = cc.Animate3D:create(animation)
        animate:setSpeed(self.speed)
        local repeatAction = cc.RepeatForever:create(animate)
        repeatAction:setTag(self:getStateType()) 
        self.sprite3d:runAction(repeatAction)
    end

    if type == EnumStateType.DEFEND then
        local x = 0
        if self:getRaceType() == EnumRaceType.HERO then
            x = -15
        else
            x = 15
        end    
        local defendAction = cc.RotateBy:create(0.5, x)
        defendAction:setTag(self:getStateType()) 
        self.sprite3d:runAction(defendAction)     
    end         
end

--getter & setter

-- get hero type
function Base3D:getRaceType()
    return self._racetype
end

function Base3D:setRaceType(type)
	self._racetype = type
end

function Base3D:getStateType()
    return self._statetype
end

function Base3D:setStateType(type)
	self._statetype = type
end

return Base3D