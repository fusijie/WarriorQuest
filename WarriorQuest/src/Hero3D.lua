
local Hero3D = class("Hero3D",function ()
	return require "Base3D".create(EnumType.HERO)
end)

function Hero3D:ctor()
    self._useWeaponId = 0
    self._useArmourId = 0
end

function Hero3D:create(type)

    local hero = Hero3D.new()
    hero:AddSprite3D(type)
	self._type = type
    
    return hero
end

function Hero3D:AddSprite3D(type)
    
    local filename;
    if type == EnumType.WARRIOR then --warrior
        filename = "Sprite3DTest/ReskinGirl.c3b"
    elseif type == EnumType.ARCHER then --archer
        filename = "Sprite3DTest/ReskinGirl.c3b"
    elseif type == EnumType.SORCERESS then --sorceress
        filename = "Sprite3DTest/ReskinGirl.c3b"
    else
        filename = "Sprite3DTest/orc.c3b" 
    end
    self._sprite3d = cc.Sprite3D:create(filename)
    local axx = self._sprite3d
    self:addChild(self._sprite3d)

    --run animation
    local animation = cc.Animation3D:create(filename)
    local animate = cc.Animate3D:create(animation)
    self._sprite3d:runAction(cc.RepeatForever:create(animate))

    --set default equipment
    self:setDefaultEqt()
end

-- set default equipments
function Hero3D:setDefaultEqt()
    local girl_lowerbody = self._sprite3d:getMeshByName("Girl_LowerBody01")
    girl_lowerbody:setVisible(false)
    local girl_shoe = self._sprite3d:getMeshByName("Girl_Shoes01")
    girl_shoe:setVisible(false)
    local girl_hair = self._sprite3d:getMeshByName("Girl_Hair01")
    girl_hair:setVisible(false)
    local girl_upperbody = self._sprite3d:getMeshByName("Girl_UpperBody01")
    girl_upperbody:setVisible(false)
end

--swicth weapon
function Hero3D:switchWeapon()
    self._useWeaponId = self._useWeaponId+1
    if self._useWeaponId > 1 then
        self._useWeaponId = 0;
    end
    if self._useWeaponId == 1 then
        local girl_lowerbody = self._sprite3d:getMeshByName("Girl_LowerBody01")
        girl_lowerbody:setVisible(true)
        local girl_lowerbody = self._sprite3d:getMeshByName("Girl_LowerBody02")
        girl_lowerbody:setVisible(false)
        local girl_shoe = self._sprite3d:getMeshByName("Girl_Shoes01")
        girl_shoe:setVisible(true)
        local girl_shoe = self._sprite3d:getMeshByName("Girl_Shoes02")
        girl_shoe:setVisible(false)
    else
        local girl_lowerbody = self._sprite3d:getMeshByName("Girl_LowerBody01")
        girl_lowerbody:setVisible(false)
        local girl_lowerbody = self._sprite3d:getMeshByName("Girl_LowerBody02")
        girl_lowerbody:setVisible(true)
        local girl_shoe = self._sprite3d:getMeshByName("Girl_Shoes01")
        girl_shoe:setVisible(false)
        local girl_shoe = self._sprite3d:getMeshByName("Girl_Shoes02")
        girl_shoe:setVisible(true)
    end
end

--switch armour
function Hero3D:switchArmour()
    self._useArmourId = self._useArmourId+1
    if self._useArmourId > 1 then
        self._useArmourId = 0;

    end
    if self._useArmourId == 1 then
        local girl_lowerbody = self._sprite3d:getMeshByName("Girl_Hair01")
        girl_lowerbody:setVisible(true)
        local girl_lowerbody = self._sprite3d:getMeshByName("Girl_Hair02")
        girl_lowerbody:setVisible(false)
        local girl_shoe = self._sprite3d:getMeshByName("Girl_UpperBody01")
        girl_shoe:setVisible(true)
        local girl_shoe = self._sprite3d:getMeshByName("Girl_UpperBody02")
        girl_shoe:setVisible(false)
    else
        local girl_lowerbody = self._sprite3d:getMeshByName("Girl_Hair01")
        girl_lowerbody:setVisible(false)
        local girl_lowerbody = self._sprite3d:getMeshByName("Girl_Hair02")
        girl_lowerbody:setVisible(true)
        local girl_shoe = self._sprite3d:getMeshByName("Girl_UpperBody01")
        girl_shoe:setVisible(false)
        local girl_shoe = self._sprite3d:getMeshByName("Girl_UpperBody02")
        girl_shoe:setVisible(true)
    end
end


-- get weapon id
function Hero3D:getWeaponID()
    return self._useWeaponId
end

-- get armour id
function Hero3D:getArmourID()
    return self._useArmourId
end

return Hero3D