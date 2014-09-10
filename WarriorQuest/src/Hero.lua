require "Cocos2d"

local Hero = class ("Hero",function ()
	return cc.Node:create()
end)

function Hero.create(hero_type)
    local hero = Hero.new()
    
    -- entity
    hero:AddEntity(hero_type)
    
    return hero
end

function Hero:AddEntity(hero_type)
    local filename;
    if hero_type == 0 then 
        filename = "Sprite3DTest/ReskinGirl.c3b"
    elseif hero_type == 1 then
        filename = "Sprite3DTest/ReskinGirl.c3b"
    else
        filename = "Sprite3DTest/ReskinGirl.c3b"
    end
    self._entity = cc.Sprite3D:create(filename)
    self:addChild(self._entity)

    --run animation
    local animation = cc.Animation3D:create(filename)
    local animate = cc.Animate3D:create(animation)
    self._entity:runAction(cc.RepeatForever:create(animate))

    --set default equipment
    self:setDefaultEqt()
end

function Hero:ctor()
	self._isalive = true
	self._blood = 1000
	self._attack = 100
	self._defense = 100
	self._useWeaponId = 0
	self._useArmour = 0
end

function Hero:walk()
	
end

function Hero:attack()

end 

function Hero:skill()
	
end

function Hero:defend()
	
end

function Hero:hurt(blood)
    self._blood = self._blood - blood
    if self._blood <= 0 then
        self._blood = 0
        self._isalive = false
    end
end

function Hero:dead()

end

function Hero:isAlive()
    return self._isalive
end

-- set default equipments
function Hero:setDefaultEqt()
    local girl_lowerbody = self._entity:getMeshByName("Girl_LowerBody01")
    girl_lowerbody:setVisible(false)
    local girl_shoe = self._entity:getMeshByName("Girl_Shoes01")
    girl_shoe:setVisible(false)
    local girl_hair = self._entity:getMeshByName("Girl_Hair01")
    girl_hair:setVisible(false)
    local girl_upperbody = self._entity:getMeshByName("Girl_UpperBody01")
    girl_upperbody:setVisible(false)
end

--swicth weapon
function Hero:switchWeapon()
    self._useWeaponId = self._useWeaponId+1
    if self._useWeaponId > 1 then
        self._useWeaponId = 0;
    end
	if self._useWeaponId == 0 then
        local girl_lowerbody = self._entity:getMeshByName("Girl_LowerBody01")
        girl_lowerbody:setVisible(true)
        local girl_lowerbody = self._entity:getMeshByName("Girl_LowerBody02")
        girl_lowerbody:setVisible(false)
        local girl_shoe = self._entity:getMeshByName("Girl_Shoes01")
        girl_shoe:setVisible(true)
        local girl_shoe = self._entity:getMeshByName("Girl_Shoes02")
        girl_shoe:setVisible(false)
	else
        local girl_lowerbody = self._entity:getMeshByName("Girl_LowerBody01")
        girl_lowerbody:setVisible(false)
        local girl_lowerbody = self._entity:getMeshByName("Girl_LowerBody02")
        girl_lowerbody:setVisible(true)
        local girl_shoe = self._entity:getMeshByName("Girl_Shoes01")
        girl_shoe:setVisible(false)
        local girl_shoe = self._entity:getMeshByName("Girl_Shoes02")
        girl_shoe:setVisible(true)
	end
end

--switch armour
function Hero:switchArmour()
    self._useArmour = self._useArmour+1
    if self._useArmour > 1 then
        self._useArmour = 0;
    end
    if self._useArmour == 0 then
        local girl_lowerbody = self._entity:getMeshByName("Girl_Hair01")
        girl_lowerbody:setVisible(true)
        local girl_lowerbody = self._entity:getMeshByName("Girl_Hair02")
        girl_lowerbody:setVisible(false)
        local girl_shoe = self._entity:getMeshByName("Girl_UpperBody01")
        girl_shoe:setVisible(true)
        local girl_shoe = self._entity:getMeshByName("Girl_UpperBody02")
        girl_shoe:setVisible(false)
    else
        local girl_lowerbody = self._entity:getMeshByName("Girl_Hair01")
        girl_lowerbody:setVisible(false)
        local girl_lowerbody = self._entity:getMeshByName("Girl_Hair02")
        girl_lowerbody:setVisible(true)
        local girl_shoe = self._entity:getMeshByName("Girl_UpperBody01")
        girl_shoe:setVisible(false)
        local girl_shoe = self._entity:getMeshByName("Girl_UpperBody02")
        girl_shoe:setVisible(true)
    end
end

return Hero